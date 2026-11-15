local vars = require("variables")

hl.config({
    decoration = {
        rounding = vars.windowRounding,
        rounding_power = vars.windowRoundingPower,

        active_opacity = vars.activeWindowOpacity,
        inactive_opacity = vars.inactiveWindowOpacity,

        blur = {
            enabled = vars.blurEnabled,
            xray = vars.blurXray,
            special = vars.blurSpecialWs,
            ignore_opacity = true,
            new_optimizations = true,
            popups = vars.blurPopups,
            input_methods = vars.blurInputMethods,
            size = vars.blurSize,
            passes = vars.blurPasses,
            brightness = vars.blurBrightness,
            noise = vars.blurNoise,
            contrast = vars.blurContrast,
            vibrancy = vars.blurVibrancy,
            vibrancy_darkness = vars.blurVibrancyDark,
        },

        motion_blur = {
            enabled = vars.motionBlurEnabled,
            samples = vars.motionBlurSamples,
        },

        wobble = {
            enabled = vars.wobbleEnabled,
            mesh = vars.wobbleMesh,
            stiffness = vars.wobbleStiffness,
            damping = vars.wobbleDamping,
            mass = vars.wobbleMass,
            intensity = vars.wobbleIntensity,
            value_epsilon = vars.wobbleValueEp,
            velocity_epsilon = vars.wobbleVelocityEp
        },

        shadow = {
            enabled = vars.shadowEnabled,
            range = vars.shadowRange,
            render_power = vars.shadowRenderPower,
            offset = vars.shadowOffset,
            color = vars.shadowColour,
        },
    },
})
