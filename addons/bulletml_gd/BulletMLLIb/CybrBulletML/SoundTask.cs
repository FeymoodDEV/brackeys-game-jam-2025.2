using BulletMLLib;
using BulletMLLib;
using BulletMLLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BulletMLLib
{
    public class SoundTask : BulletMLTask {

        public string ClipName { get; private set; }

        public SoundTask(BulletMLNode node, BulletMLTask owner) : base(node, owner) {
        
        }

        public override void InitTask(Bullet bullet) {
            base.InitTask(bullet);
        }

        public override void ParseTasks(Bullet bullet) {
            base.ParseTasks(bullet);
        }

        public override ERunStatus Run(Bullet bullet) {
            return base.Run(bullet);
        }
    }

}
