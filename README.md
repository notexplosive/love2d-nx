# LOVE2D NX: A LOVE Entity-Component System by NotExplosive

### `!! WARNING !!`

Much of the below documentation is going to be out of date. I'm ripping apart a lot of stuff that doesn't work and as a result something I say below might not be true anymore. The code samples should still work (hopefully!) but the explanations might not be 100% accurate!

## `!! /WARNING !!`

My personal setup/framework/boilerplate for LOVE2D games.

This is just a bunch of utility code and an entity component framework I made in LOVE2D. I'm just putting this up here so I have a convenient way to grab it and start projects. If you're interested in learning more about it, reach out to me on twitter, @NotExplosive.

# How do I get it?

1. Clone the repo: `git clone https://github.com/notexplosive/love2d-nx.git`
2. Rename the directory from `love2d-nx` to `my-cool-game` or whatever your game is.

From there you add components in lua in `nx/components` and write json in `/scenes`

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

## Writing the component lua

You can name a component anything you want, it just needs to be put in the `nx/components` folder or some subdirectory therein. It will be `require`'d automatically.

```lua
-- nx/components/mygame/my-component.lua

local MyComponent = {}

-- First argument must be the component "class" object
-- Second argument must be a string matching the class object, this gets added to the `Components` table
-- Third arguments is optional, but it can be a list of other component names that this component depends on
--      An assert will be fired upon adding the component if the depended components are not present.
registerComponent(MyComponent, "MyComponent", {"OtherComponentIDependOn"})

--
-- Code goes here, most likely at least one of the MyComponent:onEvent() methods
--

return MyComponent
```

There's lots of entry-points to get your component to execute code, here are all of the entry points and some notes about them:

```lua
function MyComponent:setup(some, args, to, initialize)
    -- Setup is run when the component is added
end
```

```lua
function MyComponent:awake()
    -- This runs the moment the component is added
end
```

```lua
function MyComponent:draw(x, y)
    -- This happens every frame
    -- x, y are the screen coordinates of this actor
    love.graphics.circle('fill', x, y, 20)
end
```

```lua
function MyComponent:update(dt)
    -- Same as love.update(dt)
end
```

```lua
function MyComponent:onKeyPress(key, scancode, wasRelease)
    -- Same as love.keypressed / love.keyreleased
end
```

```lua
function MyComponent:onMousePress(x, y, button, isConsumed)
    -- same as love.mousepressed / love.mousereleased ... sort of
    -- x, y are coordinates accounting for scene.camera
    if not isConsumed then
        -- Most likely your code will go here

        -- If you don't want any actor after this to be hovered, do this:
        self.actor:scene():consumeHover()
    end
end
```

```lua
function MyComponent:onMouseMove(x, y, dx, dy, isConsumed)
    -- x, y are coordinates accounting for scene.camera
    if not isConsumed then
        -- Most likely your code will go here

        -- If you don't want any actor after this to be clicked, do this:
        self.actor:scene():consumeClick()
    end
end
```

```lua
function MyComponent:onScroll(x,y)
    -- Same as love.wheelmoved
end
```

```lua
function MyComponent:onTextInput(text)
    -- Same as love.textinput
end
```

```lua
function MyComponent:onMouseFocus(focus)
    -- Same as love.mousefocus
end
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

# JSON schema

## ComponentData

A `ComponentData` is a `list` starting with a string and followed by 0 or many arguments. If more than 0 arguments are supplied, they are passed to the components `setup()` method.

Here's a `ComponentData` for a component called MyComponent with the args 1, 2, 3

```json
["MyComponent", 1, 2, 3]
```

```json
["MyOtherComponent"]
```

## ComponentList

A `ComponentList` is a list of `ComponentData` objects. Components are added in the order they are provided in the ComponentList.

This can be confusing because it ends up looking like `[[]]` in JSON and it can be very easy to lose count of your square brackets. I recomment using an autoformatter.

```json
[["MyComponent", 1, 2], ["MyOtherComponent", "hello"], ["MyThirdComponent"]]
```

## ActorData

An `ActorData` contains a field "components" which is a `ComponentList`, and optionally a `name` (string), a `pos` (list of 2 numbers) and an `angle` (number, in degrees).

`pos` defaults to `[0, 0]`

`angle` defaults to `0`

`name` is `ACTOR` followed by a random-ish number.

```json
{
  "components": [
    ["MyComponent", 1, 2],
    ["MyOtherComponent", "hello"],
    ["MyThirdComponent"]
  ],

  "pos": [200, 300],

  "name": "Steve",

  "angle: 90
}
```

The name, position, and angle, are all initialized before the components are added. The components are added in order.

## SceneData

A `SceneData` contains two elements, an object called `root` and a list called `actors`

### `root`

`root` holds a list of `ComponentList`. These ultimately get added to the an actor that is added before any other actors in the scene. The root actor isn't really any different from the other actors, it's just a convenient place to put "Global" components that don't really belong to any particular actor.

```json
{
  "root": [
    ["MyComponent", 1, 2],
    ["MyOtherComponent", "hello"],
    ["MyThirdComponent"]
  ]
}
```

### `actors`

`actors` is a list of actors. They are added in the order they are listed.

```json
{
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
