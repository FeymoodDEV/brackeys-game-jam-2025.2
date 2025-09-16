using bulletml_gd;
using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BulletMLLib;

/// <summary>
/// Defines an extensions of BulletML's <see cref="Bullet"></see> to support controlling a Godot <see cref="Node2D"/>/>
/// </summary>
public class NodeBullet : Bullet {

    /// <summary>
    /// The <see cref="Node2D"/> in the <see cref="SceneTree"/> this is the parent of the <see cref="BulletNode"/>
    /// </summary>
    protected Node2D ParentNode { get; set; }

    /// <summary>
    /// The <see cref="Node2D"/> in the <see cref="SceneTree"/> that this <see cref="Bullet"/> controls
    /// </summary>
    protected Node2D BulletNode { get; set; }

    /// <summary>
    /// A counter variable that can be used by 
    /// </summary>
    protected float Tick { get { return _tick; } }
    protected float _tick;

    protected bool used = false;


    public NodeBullet(IBulletManager manager) : base (manager){
        _tick = 0;   
    }
    public override void PostUpdate() {

    }


    public override float X {
        get => Position.X;
        set {
            var position = Position;
            position.X = value;
            Position = position;

            BulletNode.GlobalPosition = Position;
        }
    }

    public override float Y {
        get => Position.Y;
        set {
            var position = Position;
            position.Y = value;
            Position = position;

            BulletNode.GlobalPosition = Position;
        }
    }

    public Vector2 Position { get; set; }

    public bool Used {
        get => used;
        set {
            used = value;
            BulletNode.Visible = value;
        }
    }

    public void Init(Node2D parent, string bRef = "default") {
        ParentNode = parent;
        BulletNode = Data.Instance.GetBulletNode(bRef);
        ParentNode.AddChild(BulletNode);

        Used = true;
    }
}
