package 
{
	import com.ktm.genome.render.component.Transform;
	import flash.geom.Point;
	import systems.BacteriaRotationSystem;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class Contact {
		
		//Contact entre une entité (non bactérie) et un virus
		public static function virusContact(etr:Transform, vtr:Transform, radius:Number):Boolean {
			if (Math.sqrt(Math.pow(etr.x - vtr.x, 2) + Math.pow(etr.y - vtr.y, 2)) <= radius ||
				Math.sqrt(Math.pow(etr.x - (vtr.x+15), 2) + Math.pow(etr.y - vtr.y, 2)) <= radius ||
				Math.sqrt(Math.pow(etr.x - vtr.x, 2) + Math.pow(etr.y - (vtr.y+15), 2)) <= radius ||
				Math.sqrt(Math.pow(etr.x - (vtr.x+15), 2) + Math.pow(etr.y - (vtr.y+15), 2)) <= radius)
				return true;
			return false;
		}
		
		//Contact entre un virus et une bactérie
		public static function virusWithBacteryContact(vtr:Transform, btr:Transform, _btr:Transform):Boolean {
			var bacteryPoints:Vector.<Point> = BacteriaRotationSystem.getBacteryPoints(_btr);
			for each (var p:Point in bacteryPoints) {
				if (Math.sqrt(Math.pow((btr.x + p.x) - (vtr.x + 7.5), 2) + Math.pow((btr.y + p.y) - (vtr.y + 7.5), 2)) <= 7.5)
					return true;
			}
			return false;
		}
		
		//Contact entre une entité (non virus) et une bactérie
		public static function bacteryContact(etr:Transform, btr:Transform, _btr:Transform, radius:Number):Boolean {
			var bacteryPoints:Vector.<Point> = BacteriaRotationSystem.getBacteryPoints(_btr);
			for each (var p:Point in bacteryPoints) {
				if (Math.sqrt(Math.pow(etr.x - (btr.x + p.x), 2) + Math.pow(etr.y - (btr.y + p.y), 2)) <= radius)
					return true;
			}
			return false;
		}
		
		//Contact entre une toxine et une victime
		public static function toxinContact(ttr:Transform, vtr:Transform):Boolean {
			if (Math.sqrt(Math.pow(ttr.x - vtr.x, 2) + Math.pow(ttr.y - vtr.y, 2)) <= 25 ||
				Math.sqrt(Math.pow((ttr.x+25) - vtr.x, 2) + Math.pow(ttr.y - vtr.y, 2)) <= 25 ||
				Math.sqrt(Math.pow(ttr.x - vtr.x, 2) + Math.pow((ttr.y+16) - vtr.y, 2)) <= 25 ||
				Math.sqrt(Math.pow((ttr.x+25) - vtr.x, 2) + Math.pow((ttr.y+16) - vtr.y, 2)) <= 25)
				return true;
			return false;
		}
		
		//Contact entre un dechet et un macrophage
		public static function wasteContact(mtr:Transform, wtr:Transform):Boolean {
			if (Math.sqrt(Math.pow(wtr.x - mtr.x, 2) + Math.pow(wtr.y - mtr.y, 2)) <= 25 ||
				Math.sqrt(Math.pow((wtr.x+25) - mtr.x, 2) + Math.pow(wtr.y - mtr.y, 2)) <= 25 ||
				Math.sqrt(Math.pow(wtr.x - mtr.x, 2) + Math.pow((wtr.y+25) - mtr.y, 2)) <= 25 ||
				Math.sqrt(Math.pow((wtr.x+25) - mtr.x, 2) + Math.pow((wtr.y+25) - mtr.y, 2)) <= 25)
				return true;
			return false;
		}
		
		//Contact entre deux entités (non virus et non bactéries)
		public static function entityContact(etr:Transform, _etr:Transform):Boolean {
			if (Math.sqrt(Math.pow(etr.x - _etr.x, 2) + Math.pow(etr.y - _etr.y, 2)) <= 25)
				return true;
			return false;
		}
		
	}
}