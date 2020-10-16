package en;

class Item extends Entity {
	public static var ALL : Array<Item> = [];

	var type : World.Enum_Item;
	var neverPicked = true;

	public function new(t:World.Enum_Item, x,y) {
		type = t;
		super(x, y);
		xr = rnd(0.1, 0.9);
		yr = rnd(0.1, 0.9);
		ALL.push(this);

		if( spr.lib.exists("item"+type.getName()) )
			spr.set("item"+type.getName());
		else
			spr.set("itemApple");

		switch type {
			case Wood:
				spr.filter = new dn.heaps.filter.PixelOutline();

			case Apple:
				hasCartoonDistorsion = false;
		}
	}

	override function dispose() {
		super.dispose();
		ALL.remove(this);
	}

	override function onStopBeingCarried(by:Entity) {
		super.onStopBeingCarried(by);
		cd.setS("heroPickLock",0.5);
	}

	override function onBeingCarried(by:Entity) {
		super.onBeingCarried(by);
		if( by.is(en.Home) ) {
			colorMatrix.load( C.getColorizeMatrixH2d(Const.BG_COLOR, 0.4) );
			spr.alpha = 0.5;
		}


		if( neverPicked ) {
			switch type {
				case Wood:
					fx.pick(footX, footY-8);
					fx.grass(footX, footY, -dirTo(by));

				case Apple:
					fx.pick(footX, footY+4);
					fx.leaves(footX, footY+4);
			}
		}

		neverPicked = false;
	}

	override function postUpdate() {
		super.postUpdate();
		if( gravityMul==0 && !isCarried() ) {
			spr.setCenterRatio(0.5,0.2);
			spr.rotation = Math.cos(ftime*0.1 + randVal*M.PI2) * (0.2 + 0.1*randVal);
		}
		else
			spr.setCenterRatio(0.5,1);

		if( isCarried() )
			addToLayer(Const.DP_BG);
		else
			addToLayer(Const.DP_MAIN);
	}

	override function update() {
		super.update();
		if( onGround && !isCarried() && !cd.hasSetS("jump",0.4) )
			dy = -0.2;
	}
}

