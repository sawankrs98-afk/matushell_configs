use std::fs::File;
use std::num::NonZeroUsize;
use std::os::fd::AsFd;

// Nix imports for raw Linux shared memory and mmap
use nix::sys::memfd::{memfd_create, MemFdCreateFlag};
use nix::sys::mman::{mmap, munmap, MapFlags, ProtFlags};
use nix::unistd::ftruncate;

// Wayland protocol types
use wayland_client::protocol::{
    wl_buffer::WlBuffer,
    wl_compositor::WlCompositor,
    wl_registry::{self, WlRegistry},
    wl_shm::{Format, WlShm},
    wl_shm_pool::WlShmPool,
    wl_surface::WlSurface,
};
use wayland_client::{Connection, Dispatch, QueueHandle};

/*
 * ============================================================================
 * 1. OUR TOOLBOX (STATE)
 * ============================================================================
 * LAYMAN:
 *   Just like `struct ClientState` in C!
 *   In C, we wrote:
 *       struct wl_compositor *compositor = NULL;
 *   In Rust, "nullable" variables are written as `Option<T>`:
 *       None -> NULL (not bound yet)
 *       Some(object) -> we have a valid handle!
 */
#[derive(Default)]
struct ClientState {
    compositor: Option<WlCompositor>,
    shm: Option<WlShm>,
    surface: Option<WlSurface>,
}

/*
 * ============================================================================
 * 2. HELPER FUNCTION: Allocating Shared RAM
 * ============================================================================
 * LAYMAN:
 *   Asks Linux to give us an anonymous file in RAM (memfd_create),
 *   resizes it to our needed byte size (ftruncate), and gives us a Rust File.
 */
fn create_shm(size: usize) -> Result<File, Box<dyn std::error::Error>> {
    // 1. Create the RAM file. (c"..." is a null-terminated C string in Rust)
    let owned_fd = memfd_create(c"shm_pixel_buffer", MemFdCreateFlag::MFD_CLOEXEC)?;

    // 2. Resize it so it can hold our pixels (ftruncate)
    ftruncate(&owned_fd, size as i64)?;

    // 3. Convert the raw OS descriptor into a standard Rust File handle
    let file = File::from(owned_fd);
    Ok(file)
}

/*
 * ============================================================================
 * 3. THE REGISTRY LISTENER (Handling Server Announcements)
 * ============================================================================
 * LAYMAN:
 *   In C, this was `registry_handle_global`.
 *   Whenever the server announces a service over the socket,
 *   Wayland runs this function!
 */
impl Dispatch<WlRegistry, ()> for ClientState {
    fn event(
        state: &mut Self,
        registry: &WlRegistry,
        event: wl_registry::Event,
        _data: &(),
        _conn: &Connection,
        qh: &QueueHandle<ClientState>,
    ) {
        // match is just like switch/case in C, but much more powerful
        match event {
            wl_registry::Event::Global {
                name,
                interface,
                version,
            } => {
                println!("REGISTRY EVENT: Found interface '{interface}' (ID: {name}, Version: {version})");

                // Check for wl_compositor
                if interface == "wl_compositor" {
                    println!("REGISTRY ACTION: Binding to wl_compositor...");
                    // Bind using version 4 (just like our C code)
                    let compositor =
                        registry.bind::<WlCompositor, _, _>(name, version.min(4), qh, ());
                    state.compositor = Some(compositor);
                }
                // Check for wl_shm
                else if interface == "wl_shm" {
                    println!("REGISTRY ACTION: Binding to wl_shm...");
                    // Bind using version 1
                    let shm = registry.bind::<WlShm, _, _>(name, version.min(1), qh, ());
                    state.shm = Some(shm);
                }
            }
            wl_registry::Event::GlobalRemove { name } => {
                println!("REGISTRY EVENT: Global numeric ID {name} was removed");
            }
            _ => {}
        }
    }
}

/*
 * ============================================================================
 * 4. EMPTY DISPATCH BLOCKS FOR OUR PROTOCOL OBJECTS
 * ============================================================================
 * In Rust, wayland-client requires an `impl Dispatch` for every type we bind.
 * Since wl_compositor, wl_shm, and wl_surface don't send any incoming messages
 * that we need to handle right now, we leave the functions empty!
 */
impl Dispatch<WlCompositor, ()> for ClientState {
    fn event(
        _state: &mut Self,
        _proxy: &WlCompositor,
        _event: <WlCompositor as wayland_client::Proxy>::Event,
        _data: &(),
        _conn: &Connection,
        _qh: &QueueHandle<ClientState>,
    ) {
    }
}

impl Dispatch<WlShm, ()> for ClientState {
    fn event(
        _state: &mut Self,
        _proxy: &WlShm,
        _event: <WlShm as wayland_client::Proxy>::Event,
        _data: &(),
        _conn: &Connection,
        _qh: &QueueHandle<ClientState>,
    ) {
    }
}

impl Dispatch<WlShmPool, ()> for ClientState {
    fn event(
        _state: &mut Self,
        _proxy: &WlShmPool,
        _event: <WlShmPool as wayland_client::Proxy>::Event,
        _data: &(),
        _conn: &Connection,
        _qh: &QueueHandle<ClientState>,
    ) {
    }
}

impl Dispatch<WlBuffer, ()> for ClientState {
    fn event(
        _state: &mut Self,
        _proxy: &WlBuffer,
        _event: <WlBuffer as wayland_client::Proxy>::Event,
        _data: &(),
        _conn: &Connection,
        _qh: &QueueHandle<ClientState>,
    ) {
    }
}

impl Dispatch<WlSurface, ()> for ClientState {
    fn event(
        _state: &mut Self,
        _proxy: &WlSurface,
        _event: <WlSurface as wayland_client::Proxy>::Event,
        _data: &(),
        _conn: &Connection,
        _qh: &QueueHandle<ClientState>,
    ) {
    }
}

/*
 * ============================================================================
 * 5. MAIN LOGIC
 * ============================================================================
 */
fn main() {
    // Create our empty state toolbox
    let mut state = ClientState::default();

    // 1. Connect to the Wayland server socket (like wl_display_connect(NULL) in C)
    let conn = match Connection::connect_to_env() {
        Ok(c) => c,
        Err(err) => {
            eprintln!("Failed to connect to Wayland server: {err}");
            return;
        }
    };
    println!("The wayland display successfully connected to the socket...");

    // 2. Request the registry and create the event queue (like wl_display_get_registry in C)
    let (_globals, mut event_queue) =
        match wayland_client::globals::registry_queue_init::<ClientState>(&conn) {
            Ok(res) => res,
            Err(err) => {
                eprintln!("Failed to get registry: {err}");
                return;
            }
        };

    // A QueueHandle (qh) is used whenever we create new Wayland objects
    let qh = event_queue.handle();

    // 3. Perform roundtrip (like wl_display_roundtrip in C)
    // This pauses until the server sends all its global announcements!
    println!("Performing round trip to sync all the things before executing code");
    if let Err(err) = event_queue.roundtrip(&mut state) {
        eprintln!("Roundtrip error: {err}");
        return;
    }

    // 4. Check if both wl_compositor and wl_shm were bound
    if state.compositor.is_none() || state.shm.is_none() {
        println!("wl_compositor or wl_shm was not advertised by the compositor...");
        return;
    }

    println!("Compositor bound successfully... Creating a wl_surface");

    // Pull out references to our bound globals
    let compositor = state.compositor.as_ref().unwrap();
    let shm = state.shm.as_ref().unwrap();

    // 5. Create a surface (canvas)
    let surface = compositor.create_surface(&qh, ());

    // 6. Image dimensions
    let width: i32 = 100;
    let height: i32 = 100;
    let stride: i32 = width * 4; // 4 bytes per pixel (XRGB)
    let size: usize = (stride * height) as usize; // 40,000 bytes

    // 7. Allocate RAM file using our helper function
    let file = match create_shm(size) {
        Ok(f) => f,
        Err(err) => {
            eprintln!("Failed to allocate shared RAM: {err}");
            return;
        }
    };

    // 8. Memory map the RAM and paint cyan pixels
    // mmap touches raw memory pointers, so Rust requires an unsafe block here
    unsafe {
        let mmap_size = NonZeroUsize::new(size).unwrap();

        // Call Linux mmap()
        let mmap_result = mmap(
            None,
            mmap_size,
            ProtFlags::PROT_READ | ProtFlags::PROT_WRITE,
            MapFlags::MAP_SHARED,
            &file,
            0,
        );

        match mmap_result {
            Ok(addr) => {
                // Treat the mapped memory as an array of 32-bit pixel numbers
                let pixel_slice =
                    std::slice::from_raw_parts_mut(addr as *mut u32, (width * height) as usize);

                // Paint every single pixel Solid Cyan (0x0000FFFF)
                for pixel in pixel_slice.iter_mut() {
                    *pixel = 0x0000_FFFF;
                }

                // 9. Create the Wayland pool and slice out the buffer
                let pool = shm.create_pool(file.as_fd(), size as i32, &qh, ());
                let buffer = pool.create_buffer(
                    0,                // offset in bytes
                    width,            // width
                    height,           // height
                    stride,           // stride (bytes per line)
                    Format::Xrgb8888, // 32-bit pixel format
                    &qh,
                    (),
                );

                // Pool can be destroyed once the buffer is created
                pool.destroy();

                // 10. Attach buffer to surface and commit!
                surface.attach(Some(&buffer), 0, 0);
                surface.commit();

                // Push all pending messages across the socket immediately
                let _ = conn.flush();
                println!("Request queued and flushed to server successfully...");

                // 11. Roundtrip to let the server process the commit
                let _ = event_queue.roundtrip(&mut state);

                // Clean up memory map and buffer
                let _ = munmap(addr, size);
                buffer.destroy();
            }
            Err(err) => {
                eprintln!("mmap failed: {err}");
            }
        }
    }

    // 12. Destroy surface cleanly
    surface.destroy();
    println!("SURFACE DESTROYED CLEANLY...");

    println!("cleaning everything gracefully...");
    println!("Disconnected cleanly...");
}
