using BulletMLLib;
using Godot;
using Godot.Collections;

namespace bulletml_gd;

/// <summary>
/// <see cref="FunctionBullet"/> Represents a 
/// </summary>
public class FunctionBullet : NodeBullet
{

    public BulletFunction Function { get; set; }
    public Vector2 Offset { get; set; }

    public FunctionBullet(IBulletManager manager, BulletFunction function) : base(manager) { 
        _tick = 0;
        Function = function;
        Speed = function.Speed;
    }

    public override void PostUpdate() {
        var cam = BulletNode.GetViewport().GetCamera2D();

        var rect = cam.GetViewportRect();

        _tick = Mathf.Wrap(_tick, 0, 25);
    }

    private void SinMovement() {
        //Flag to tell whether or not this bullet has finished all its tasks
        _tick += ((float)Time.PhysicsDelta);

        var x = 0.0f;
        var y = 0.0f;

        Vector2 pos;
        if (Function.CoordType == CoordType.Polar){ 
            var r = ((float)Function.XFunc.Execute([Tick]));
            x = (Mathf.Cos(Tick) * r);
            y = Mathf.Sin(Tick) * r;
            pos = new Vector2(x, y);
        }else{
            x = ((float)Function.XFunc.Execute([Tick]));
            y = ((float)Function.YFunc.Execute([Tick]));
            pos = new Vector2(x, y);
        }




        var nextPos = Acceleration + new Vector2(x, y).Rotated(ParentNode.Rotation) * Speed;

        GD.Print(nextPos);

        X = MathHelper.SmoothStep(X, nextPos.X, Speed * Time.PhysicsDelta);
        Y = MathHelper.SmoothStep(Y, nextPos.Y, Speed * Time.PhysicsDelta);
    }

    private void EllipseMovement(float skewX, float skewY) {
        //Flag to tell whether or not this bullet has finished all its tasks
        _tick += ((float)Time.PhysicsDelta);
        //only do this stuff if the bullet isn't done, cuz sin/cosin are expensive
        X += 20 * ((float)Mathf.Cos(2 * Tick)) / skewX;
        Y += 20 * ((float)Mathf.Sin(2 * Tick)) / skewY;
    }

    /// <summary>
    /// Update this bullet.  Called once every 1/60th of a second during runtime
    /// </summary>
    public override void Update() {
        SinMovement();
    }
}
