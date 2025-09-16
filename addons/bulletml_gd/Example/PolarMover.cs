using BulletMLLib;
using BulletMLLib;
using BulletMLLib;
using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bulletml_gd{
    /// <summary>
    /// Extended Mover class that can move based on Polar Coordinates
    /// </summary>

    public class PolarMover : MarkupBullet {
        public float tick;

        public PolarMover(IBulletManager myBulletManager) : base(myBulletManager) {
            
        }

        public override void Update() {
            tick += ((float)BulletNode.GetPhysicsProcessDeltaTime());

            X += Speed * Direction * Mathf.Cos(Direction * tick);
            Y += Speed * Direction * Mathf.Sin(Direction * tick);
            BulletNode.Rotation = Direction + 45;
        }
    }
}
