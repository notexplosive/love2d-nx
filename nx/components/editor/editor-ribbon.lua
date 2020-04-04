local sceneLayers = require("nx/scene-layers")
local EditorRibbon = {}

registerComponent(EditorRibbon, "EditorRibbon", {"BoundingBox"})

function EditorRibbon:awake()
    self:onActorDeselect()
end

function EditorRibbon:onActorDeselect()
    self:clearChildren()
    self:createRibbonButton(
        "create",
        0,
        function()
            self:createPlaceButton(1, "Target", Components.BecomeTarget, 1)
            self:createPlaceButton(2, "Player", Components.BecomePlayer, 1)
            self:createPlaceButton(3, "Wall", Components.BecomeWall, 100, 100, "grass")
        end
    )
    self:createRibbonButton(
        "save",
        2,
        function()
            local debugScene = sceneLayers:peek()
            debugScene:getFirstBehavior(Components.SaveMap):save()
        end
    )
end

function EditorRibbon:createPlaceButton(index, buttonLabel, componentClass, ...)
    local args = {...}
    self:createExtendedButton(
        buttonLabel,
        index,
        function()
            self:placeActorWith(componentClass, unpack(args))
            self:clearChildren()
            self:createRibbonLabel("Create Target", 1)
        end
    )
end

function EditorRibbon:placeActorWith(componentClass, ...)
    if self.pendingPlaceActor then
        self.pendingPlaceActor:destroy()
    end

    self.pendingPlaceActor =
        self.actor:scene():addActor("Place" .. componentClass.name):addComponent(
        Components.PlaceActorWith,
        componentClass,
        ...
    )
end

function EditorRibbon:onActorSelect(actor)
    self:clearChildren()
    local textLabel = self:createRibbonLabel(actor.name, 1)
    self:createRibbonButton(
        "delete",
        3,
        function()
            actor:destroy()
            self:onActorDeselect()
        end
    )
    self:createRibbonButton(
        "bring-to-front",
        4,
        function()
            actor:scene():sendToBack(actor)
        end
    )
    self:createRibbonButton(
        "send-to-back",
        5,
        function()
            actor:scene():bringToFront(actor)
        end
    )
    self:createRibbonButton(
        "delete",
        7,
        function()
            self:onActorDeselect()
        end
    )
end

function EditorRibbon:clearChildren()
    if not self.actor.Children then
        return
    end

    local children = self.actor.Children:get()
    for i, actor in ipairs(children) do
        actor:destroy()
    end
end

function EditorRibbon:createChildOnRibbon(index)
    local child = self.actor:scene():addActor()
    child:addComponent(Components.Parent, self.actor)
    child:addComponent(Components.AffixPos, self.actor, 8 + 16 + 32 * index, 8 + 16)

    return child
end

function EditorRibbon:createChildBelowRibbon(index)
    local child = self.actor:scene():addActor()
    child:addComponent(Components.Parent, self.actor)
    child:addComponent(Components.AffixPos, self.actor, 0, 16 + 32 * index)

    return child
end

function EditorRibbon:createExtendedButton(label, index, func)
    local child = self:createChildBelowRibbon(index)

    child:addComponent(Components.BoundingBox, 128, 32)
    child:addComponent(Components.EditorRibbonBackground)
    child:addComponent(
        Components.TextRenderer,
        label,
        16,
        self.actor.BoundingBox:width(),
        "left",
        1,
        {1, 1, 1, 1},
        8,
        8
    )
    child:addComponent(Components.Hoverable)
    child:addComponent(Components.Clickable)

    child:addComponent(
        Components.OnClickDo,
        func or function()
                debugLog("no function")
            end
    )

    return child
end

function EditorRibbon:createRibbonButton(label, index, func)
    local child = self:createChildOnRibbon(index)

    child:addComponent(Components.BoundingBox, 32, 32)
    child:addComponent(Components.SpriteRenderer, "editor-icons", label)
    child:addComponent(Components.Hoverable)
    child:addComponent(Components.Clickable)
    child:addComponent(Components.SpriteButtonRenderer)

    child:addComponent(
        Components.OnClickDo,
        func or function()
                debugLog("no function")
            end
    )

    return child
end

function EditorRibbon:createRibbonLabel(text, index)
    local child = self:createChildOnRibbon(index)
    child:addComponent(Components.TextRenderer, text, 16, 128, "left", 1, {1, 1, 1, 1}, -32 - 16, -8)

    return child
end

return EditorRibbon
