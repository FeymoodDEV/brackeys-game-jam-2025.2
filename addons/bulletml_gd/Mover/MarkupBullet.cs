using BulletMLLib;
using Equationator;
using Godot;

namespace bulletml_gd;

public enum MoverType{
    BulletML,
    Circle,
    Elipse,
    Sin,
    Throw,
}

/// <summary>
/// Defines a <see cref="NodeBullet"/> that will follow the
/// </summary>
public class MarkupBullet : NodeBullet
{
    private double tick;

    public MoverType Type { get; set; }

    public MarkupBullet(IBulletManager myBulletManager)
        : base(myBulletManager) { }

    public override void Update() {
        base.Update();
        //BulletNode.Rotation += ((float)Time.PhysicsDelta) * Speed;
    }

    public override void PostUpdate()
    {

    }
}
