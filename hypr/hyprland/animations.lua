-- Animation profile loader. The active profile is set by the animationProfile
-- variable (see variables.lua / user/variables.lua overrides)
local vars = require("variables")

local profiles = { "m3-expressive", "m3-hybrid", "m3-standard", "simple" }

local function active_profile()
    for _, name in ipairs(profiles) do
        if name == vars.animationProfile then
            return name
        end
    end
    return "m3-hybrid" -- Fallback for an unknown animationProfile
end

require("animations." .. active_profile())
