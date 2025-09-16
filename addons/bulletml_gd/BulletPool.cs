using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Godot;

namespace bulletml_gd;

public partial class BulletPool : Node {

    private static BulletPool instance;
    public static BulletPool Instance { get{
        if (instance == null){
            instance = new BulletPool();
        }
        return instance;
    } }

    private BulletPool(){
       
    }
}