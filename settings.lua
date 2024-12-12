local is_space_age_available = mods['space-age'] ~= nil

local base_settings = {
    "global-multiplier",
    "essential-research-multiplier",
    "infinite-research-multiplier",
};


local pack_settings = {
    "automation-science-multiplier",
    "logistic-science-multiplier",
    "military-science-multiplier",
    "chemical-science-multiplier",
    "production-science-multiplier",
    "utility-science-multiplier",
    "space-science-multiplier",
};

if is_space_age_available then
    table.insert(base_settings, "interplanetary-research-multiplier");
    table.insert(base_settings, "planet-discovery-research-multiplier");

    table.insert(pack_settings, "metallurgic-science-multiplier");
    table.insert(pack_settings, "electromagnetic-science-multiplier");
    table.insert(pack_settings, "agricultural-science-multiplier");
    table.insert(pack_settings, "cryogenic-science-multiplier");
    table.insert(pack_settings, "promethium-science-multiplier");
end

local settings = {}

-- helper function for acquiring a stable ordering string, fuck my life
function get_order(value)
    local result = "";
    if value >= 26 then
      for _=1, (value/26) do
        result = result .. string.char(97 + 26 - 1);
      end
      value = value % 26;
    end
    result = result .. string.char(97 + value - 1);
    return result
end

-- helper for adjusting all options for settings
function add_setting(name, order)
    table.insert(settings, {
        type = "double-setting",
        name = name,
        setting_type = "startup",
        order = order,
        minimum_value = 0.000000000001,
        default_value = 1.0,
    })
end

for index, setting_name in pairs(base_settings) do
    add_setting(setting_name, get_order(index));
end

for index, setting_name in pairs(pack_settings) do
    add_setting(setting_name, get_order(index + #base_settings));
end

data:extend(settings)