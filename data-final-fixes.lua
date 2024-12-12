local global_multiplier = settings.startup["global-multiplier"].value
local essential_research_multiplier = settings.startup["essential-research-multiplier"].value
local infinite_research_multiplier = settings.startup["infinite-research-multiplier"].value
local interplanetary_research_multiplier = settings.startup["interplanetary-research-multiplier"].value
local planet_discovery_research_multiplier = settings.startup["planet-discovery-research-multiplier"].value

local multiplier_mode = "override";

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

-- 
function is_interplanetary_research(name)
    for _, ingredient in pairs(data.raw.technology[name].unit.ingredients) do
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

for name, technology in pairs(data.raw.technology) do
    -- skip trigger technology
    if (technology.research_trigger ~= nil) then
        goto continue;
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

    -- TODO: science pack multiplier

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
        goto continue;
    elseif (multiplier <= 0) then
        log("Multiplier is less than 0, skipping " .. name .. " (" .. multiplier .. ")")
        goto continue;
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
            technology.unit.count = math.max(math.ceil(technology.unit.count*multiplier), 1)
        else
            technology.unit.count = technology.unit.count*multiplier;
        end
    end

    ::continue::
end