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

    ::continue::
end