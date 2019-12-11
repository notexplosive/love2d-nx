# LOVE2D NX: A LOVE Entity-Component System by NotExplosive

My personal setup/framework/boilerplate for LOVE2D games.

This is just a bunch of utility code and an entity component framework I made in LOVE2D. I'm just putting this up here so I have a convenient way to grab it and start projects. If you're interested in learning more about it, reach out to me on twitter, @NotExplosive.

# Quickstart (with JSON)

By default the game scene `scenes/game.json` looks something like this:

```json
{
  "root": [["CloseOnEscape"]],
  "actors": [
    {
      "components": [["TriangleRenderer", 20], ["RotateTowardsMouse"]],
      "pos": [200, 200]
    },
    {
      "components": [["CircleRenderer", 20]],
      "pos": [300, 200]
    },
    {
      "components": [["RectRenderer", 40, 40], ["RandomRotate"]],
      "pos": [400, 200]
    }
  ]
}
```

You can load `game.json` by doing the following. This is already included in `main.lua` so you don't actually need to write this:

```lua
local Scene = require("nx/game/scene")
gameScene = Scene.fromPath("game")
sceneLayers:add(gameScene)
```

# Quickstart (Without JSON)

This will show you how to write the equivalent code to the above JSON instructions but without using the JSON.

```lua
local sceneLayers = require("nx/scene-layers")
local Scene = require("nx/game/scene")
-- Load scenes/game.json into the gameScene object
gameScene = Scene.fromPath("game")
sceneLayers:add(gameScene)

-- Root is just like any other actor, it's a convenient place to attach components that affect the whole world
-- For example: if you hit the escape key, the window closes.
local root = gameScene:addActor()
root:addComponent(Components.CloseOnEscape)

-- Actor 1 renders as a triangle that points towards the mouse
local actor1 = gameScene:addActor()
actor1:addComponent(Components.TriangleRenderer, 20)
actor1:addComponent(Components.RotateTowardsMouse)
actor1:setPos(200, 200)

-- Actor 2 renders as a circle
local actor2 = gameScene:addActor()
actor2:addComponent(Components.CircleRenderer, 20)
actor2:setPos(300, 200)

-- Actor 3 renders as a rect that rotates randomly
local actor3 = gameScene:addActor()
actor3:addComponent(Components.RectRenderer, 40, 40)
actor3:addComponent(Components.RandomRotate)
actor3:setPos(400, 200)
```

# How to write a component

## Component lua

You can name a component anything you want, it just needs to be put in the `nx/components` folder or some subdirectory therein. It will be `require`'d automatically.

You can include all or none of these methods.

```lua
-- nx/components/mygame/my-component.lua

local MyComponent = {}

registerComponent(MyComponent, "MyComponent")

function MyComponent:setup(some, args, to, initialize)
    -- Setup is run when the component is added, see below
end

function MyComponent:awake()
    -- This runs the moment the component is added
end

function MyComponent:draw(x, y)
    -- This happens every frame
    -- x, y are the screen coordinates of this actor

    love.graphics.circle('fill', x, y, 20)
end

function MyComponent:update(dt)
    -- Same as love.update(dt)
end

function MyComponent:onKeyPress(key, scancode, wasRelease)
    -- Same as love.keypressed / love.keyreleased

    if key == "space" and not wasRelease then
        debugLog("You pressed space")
    end
end

function MyComponent:onMousePress(x, y, button, isConsumed)
    -- same as love.mousepressed / love.mousereleased ... sort of
    -- x, y are coordinates accounting for scene.camera

    if not isConsumed then
        -- Most likely your code will go here

        -- If you don't want any actor after this to be hovered, do this:
        self.actor:scene():consumeHover()
    end
end

function MyComponent:onMouseMove(x, y, dx, dy, isConsumed)
    -- x, y are coordinates accounting for scene.camera

    if not isConsumed then
        -- Most likely your code will go here

        -- If you don't want any actor after this to be clicked, do this:
        self.actor:scene():consumeClick()
    end

end

function MyComponent:onScroll(x,y)
    -- Same as love.wheelmoved

    -- Move the camera on scroll
    self.actor:scene().camera.y = self.actor:scene().camera.y - y
end

function MyComponent:onTextInput(text)
    -- Same as love.textinput
end

function MyComponent:onMouseFocus(focus)
    -- Same as love.mousefocus
end

return MyComponent
```

When you want to add the component to an actor, you can do the following:

## With straight lua:

```lua
local actor = gameScene:addActor()
actor:addComponent(Components.MyComponent) -- runs awake() but **NOT** setup(), this might be bad design so I might reconsider this

-- alternatively...
actor:addComponent(Components.MyComponent, some, args, to, initialize) -- runs awake() and then setup(some, args, to, initialize)
```

## With JSON

The json file needs to live `/scenes` or some subdirectory therein. You'll then need to load it with `Scene.fromPath` as seen above

The following will run `awake()` and then `setup("someString", {argTable = 420}, 69, nil)`

```json
{
  "root": [],
  "actors": [
    {
      "components": [
        ["MyComponent", "someString", { "argTable": 420 }, 69, null]
      ],
      "pos": [200, 200]
    }
  ]
}
```
