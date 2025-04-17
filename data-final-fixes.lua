local is_space_age_available = mods['space-age'] ~= nil

local multiplier_mode = "override";

local global_multiplier = settings.startup["global-multiplier"].value
local essential_research_multiplier = settings.startup["essential-research-multiplier"].value
local infinite_research_multiplier = settings.startup["infinite-research-multiplier"].value

local interplanetary_research_multiplier = 1;
local planet_discovery_research_multiplier = 1;
if is_space_age_available then
    interplanetary_research_multiplier = settings.startup["interplanetary-research-multiplier"].value
    planet_discovery_research_multiplier = settings.startup["planet-discovery-research-multiplier"].value
end

local science_pack_multiplier_ids = {
    "automation-science-multiplier",
    "logistic-science-multiplier",
    "military-science-multiplier",
    "chemical-science-multiplier",
    "production-science-multiplier",
    "utility-science-multiplier",
    "space-science-multiplier",
};

if is_space_age_available then
    for _, id in pairs({
        "metallurgic-science-multiplier",
        "electromagnetic-science-multiplier",
        "agricultural-science-multiplier",
        "cryogenic-science-multiplier",
        "promethium-science-multiplier",
    }) do
        table.insert(science_pack_multiplier_ids, id);
    end
end

local science_pack_multipliers = {};
for _, id in pairs(science_pack_multiplier_ids) do
    science_pack_multipliers[id] = settings.startup[id].value;
end

local science_pack_multiplier_translation = {
    ["automation-science-pack"] = "automation-science-multiplier",
    ["logistic-science-pack"] = "logistic-science-multiplier",
    ["military-science-pack"] = "military-science-multiplier",
    ["chemical-science-pack"] = "chemical-science-multiplier",
    ["production-science-pack"] = "production-science-multiplier",
    ["utility-science-pack"] = "utility-science-multiplier",
    ["space-science-pack"] = "space-science-multiplier",
    ["metallurgic-science-pack"] = "metallurgic-science-multiplier",
    ["electromagnetic-science-pack"] = "electromagnetic-science-multiplier",
    ["agricultural-science-pack"] = "agricultural-science-multiplier",
    ["cryogenic-science-pack"] = "cryogenic-science-multiplier",
    ["promethium-science-pack"] = "promethium-science-multiplier",
}

-- optimization step: remove translations for multipliers that are 1.0 (default)
for pack_item, multiplier_key in pairs(science_pack_multiplier_translation) do
    local multiplier = science_pack_multipliers[multiplier_key];
    if multiplier == 1.0 then
        science_pack_multiplier_translation[pack_item] = nil;
    end
end

function as_set(table)
    local set = {}
    for _, v in pairs(table) do
        set[v] = true
    end
    return set
end

-- as defined by Factorio's technology tree; yes, some of this is redundant as they're trigger-based, but I would rather be technically correct
local essential_research = as_set({
    "automation-science-pack",
    "logistic-science-pack",
    "military-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack",
    "rocket-silo",
    "space-science-pack",
    "planet-discovery-vulcanus",
    "metallurgic-science-pack",
    "planet-discovery-fulgora",
    "electromagnetic-science-pack",
    "planet-discovery-gleba",
    "agricultural-science-pack",
    "planet-discovery-aquilo",
    "cryogenic-science-pack",
    "promethium-science-pack",
});

-- used for 'pack' multiplier mode
local science_packs = {
    "automation-science-pack",
    "logistic-science-pack",
    "military-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack",
    "space-science-pack",
    "metallurgic-science-pack",
    "electromagnetic-science-pack",
    "agricultural-science-pack",
    "cryogenic-science-pack",
    "promethium-science-pack",
}

-- used for detecting interplanetary research
local interplanetary_science_packs = as_set({
    "metallurgic-science-pack",
    "electromagnetic-science-pack",
    "agricultural-science-pack",
    "cryogenic-science-pack",
    "promethium-science-pack",
})

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function is_essential_research(name)
    return essential_research[name] == true;
end

-- infinite research generally has a finite number of defined 'levels', ones that don't have a formula. this function does not account for them.
function is_infinite_research(name)
    return data.raw.technology[name].unit.count == nil;
end

-- This function expects that the technology exists, and follows the TechnologyUnit type specification properly
function is_interplanetary_research(name)
    local technology = data.raw.technology[name];

    if technology.unit == nil then
        return false;
    end

    for _, ingredient in pairs(technology.unit.ingredients) do
        if interplanetary_science_packs[ingredient[1]] then
            return true;
        end
    end

    return false;
end

function is_planet_discovery_research(name)
    local start = string.find(name, "planet-discovery-", 1, true)
    return start == 1;
end

function multiply(current, next)
    if multiplier_mode == "override" then
        return next;
    elseif multiplier_mode == "multiply" then
        return current * next;
    elseif multiplier_mode == "add" then
        return current + (next - 1);
    end
end

function calculate(name, technology)
    -- Skip trigger technology, or technologies that don't properly provide a `unit`, `unit.ingredients`, or `unit.count` property
    if (technology.research_trigger ~= nil) then
        return;
    elseif (technology.unit == nil or technology.unit.ingredients == nil) then
        log("Skipping non-trigger technology \"" ..
            name .. "\" because it doesn't properly define a unit, it's ingredients, and/or a count.")
    end

    -- default to the global multiplier
    local multiplier = global_multiplier;

    -- essential research
    if (essential_research_multiplier ~= 1 and is_essential_research(name)) then
        multiplier = multiply(multiplier, essential_research_multiplier);
    end

    -- infinite research
    if (infinite_research_multiplier ~= 1 and is_infinite_research(name)) then
        multiplier = multiply(multiplier, infinite_research_multiplier);
    end

    -- interplanetary research
    if (interplanetary_research_multiplier ~= 1 and is_interplanetary_research(name)) then
        multiplier = multiply(multiplier, interplanetary_research_multiplier);
    end

    -- planet discovery research
    if (planet_discovery_research_multiplier ~= 1 and is_planet_discovery_research(name)) then
        multiplier = multiply(multiplier, planet_discovery_research_multiplier);
    end

    -- science pack multiplier (flat, not ingredient-based)
    for _, ingredient in pairs(technology.unit.ingredients) do
        local ingredient_multiplier_id = science_pack_multiplier_translation[ingredient[1]];

        if ingredient_multiplier_id ~= nil then
            local pack_multiplier = science_pack_multipliers[ingredient_multiplier_id];
            multiplier = multiply(multiplier, pack_multiplier);
        end
    end

    -- debug printing
    if (technology.unit) then
        if (technology.unit.count ~= nil) then
            log(name .. " : " .. technology.unit.count .. " -> x" .. multiplier)
        else
            log(name .. " : " .. '??' .. " -> x" .. multiplier)
        end
    end

    -- TODO: Reduce multiplier precision to 3 decimal places

    -- don't apply multiplier if it would do nothing
    if (multiplier == 1) then
        return
    elseif (multiplier <= 0) then
        log("Multiplier is less than 0, skipping " .. name .. " (" .. multiplier .. ")")
        return
    end

    -- Multiplier has been calculated, apply it
    if (technology.unit.count_formula) then
        -- formula-based
        if (multiplier < 1) then
            -- if multiplier is less than 100%, we need to ensure the result is at least 1
            -- MathExpression has a max() function for formulas
            technology.unit.count_formula = 'max(1, ' .. technology.unit.count_formula .. ')*' .. multiplier
        else
            technology.unit.count_formula = '(' .. technology.unit.count_formula .. ')*' .. multiplier
        end
    else
        -- simple count
        if (multiplier < 1) then
            technology.unit.count = math.max(math.ceil(technology.unit.count * multiplier), 1)
        else
            technology.unit.count = technology.unit.count * multiplier;
        end
    end
end

for name, technology in pairs(data.raw.technology) do
    xpcall(calculate, function(err)
        log("Error in technology " .. name .. ": " .. err)
    end, name, technology)
end
