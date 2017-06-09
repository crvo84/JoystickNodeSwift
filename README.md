# JoystickNodeSwift

## Swift implementation of the awesome KAZ_JoystickNode </br>
----------
### [Original project (Objective-C): https://github.com/kazmiekr/joysticknode]

## A Simple Virtual Joystick made for the Apple Sprite Kit Framework

Creates a virtual onscreen joystick composed of 2 circles which you can configure with any sprite name you'd like.  Options include ability to dynamically show the control when the user taps and center itself on the tap or can be used as a fixed controller

The sample application shows how to use them in a simple move/shoot scenario similar to a lot of games of this style.

### Basic Usage

```swift
let moveJoystick = KAZJoystickNode()
moveJoystick.setOuterControl(withImageName: "outer", alpha: 0.25)
moveJoystick.setInnerControl(withImageName: "inner", alpha: 0.50)
moveJoystick.movePoints = 8
addChild(moveJoystick)
```

This will create the joystick with using an image named 'outer' for the outer circle and a 0.25 alpha, and an image named 'inner' for the inner circle at 0.5 alpha.  The speed will be scaled from 0-8.

### Basic Flow

On your scene, you will start control on touchesBegan

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
        let location = touch.location(in: self)
        // Add some conditional to determine if the touch is one you want to use to control the joystick
        if location.x < 200 && location.y < 200 {
            moveJoystick.startControl(fromTouch: touch, location: location)
        }
    }
}
```

This will tell the control to show and start controlling using the specified point and location if they tap in the lower area of the screen

Then during touch moves, you'll update the control with:

```swift
override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
        let location = touch.location(in: self)
        if touch == moveJoystick.startTouch {
            moveJoystick.moveControl(toTouch: touch, location: location)
        }
    }
}
```

This will tell the joystick of the new movements

Then to end control, you'll do:

```swift
override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
        if touch == moveJoystick.startTouch {
            moveJoystick.endControl()
        }
    }
}
```

### Fixed Example

To have a fixed control, you'd follow the same flow except configure it a bit differently

```swift
let moveJoystick = KAZJoystickNode()
moveJoystick.setOuterControl(withImageName: "outer", alpha: 0.25)
moveJoystick.setInnerControl(withImageName: "inner", alpha: 0.5,
                             nodeName: "MoveJoystick")
moveJoystick.movePoints = 8
moveJoystick.autoShowHide = false
moveJoystick.position = CGPoint(x: 150, y: 180)
addChild(moveJoystick)
```

The only difference from the dynamic version is that you supply a name to the inner control so you can easily determine if they tapped on it, changed autoShowHide to NO and supplied a position.

Then when you start control, you'd do something like:

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        if let _ = (touchedNodes.filter { $0.name == "MoveJoystick" }).first {
            moveJoystick.startControl(fromTouch: touch, location: location)
        }
    }
}
```

### Controlling your objects

Once you have movement you can control whatever sprite you'd like probably from the update method.

For example if you wanted to move a ship you could do something like this during the update method:

```swift
if moveJoystick.isMoving {
    let adjustedSpritePosition = CGPoint(x: sprite.position.x + moveJoystick.moveSize.width, 
                                         y: sprite.position.y + moveJoystick.moveSize.height)
    sprite.position = adjustedSpritePosition
}
```

It'll adjust the ships position based on it's current location plus the movement size from the controller

You could also read the registered angle to apply something at an angle.  See the sample code on how to shoot objects at that angle.

### Properties

#### isMoving

Flag to know when the control is registering movements

#### autoShowHide

Defaults to YES.  Will show the control when the start touch gets registered

#### moveSize

The size of the movement the control calculates.  Based on the speed and angle, it'll generate a movement in the x/y space for you to apply to any node.

#### startTouch

The touch to register movement with the control

#### movePoints

The amount you want to adjust the object speed by.  Will be scaled based on the distance from the center point to the outer ring

#### angle

The angle being reported by the movment of the inner circle.  0 is directly to the right, 180 is is directly to left, 90 is at the top, and -90 is at the bottom

#### defaultAngle

The angle to report if there is no movement, the control will reset to this

### Screenshots

![ScreenShot](https://raw.github.com/kazmiekr/joysticknode/master/dynamic.png)

![ScreenShot](https://raw.github.com/kazmiekr/joysticknode/master/fixed.png)
