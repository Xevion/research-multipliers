local global_multiplier = settings.startup["global-multiplier"].value
local essential_research_multiplier = settings.startup["essential-research-multiplier"].value
local infinite_research_multiplier = settings.startup["infinite-research-multiplier"].value

-- as defined by Factorio's technology tree; yes, some of this is redundant as they're trigger-based, but I would rather be technically correct
local essential_research = {
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
};

for name, technology in pairs(data.raw.technology) do
    -- skip trigger technology
    if (technology.research_trigger ~= nil) then
        goto continue;
    end

    local multiplier = global_multiplier;

    if (technology.unit) then
        if (technology.unit.count ~= nil) then
            log(name .. " : " .. technology.unit.count .. " -> x" .. multiplier)
        else
            log(name .. " : " .. '??' .. " -> x" .. multiplier)
        end
    else
        log(name .. " : trigger=" .. technology.research_trigger.type)
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