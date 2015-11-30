package 
{
	import com.ktm.genome.render.component.Transform;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class Contact {
		
		//Contact entre une entité et un virus
		public static function virusContact(etr:Transform, vtr:Transform, radius:Number):Boolean {
			if (Math.sqrt(Math.pow(etr.x - vtr.x, 2) + Math.pow(etr.y - vtr.y, 2)) <= radius ||
				Math.sqrt(Math.pow(etr.x - (vtr.x+15), 2) + Math.pow(etr.y - vtr.y, 2)) <= radius ||
				Math.sqrt(Math.pow(etr.x - vtr.x, 2) + Math.pow(etr.y - (vtr.y+15), 2)) <= radius ||
				Math.sqrt(Math.pow(etr.x - (vtr.x+15), 2) + Math.pow(etr.y - (vtr.y+15), 2)) <= radius)
				return true;
			return false;
		}
		
		//A CHANGER
		public static function bacteriaContact(lbtr:Transform, btr:Transform, radius:Number):Boolean {
			if (Math.sqrt(Math.pow(lbtr.x - btr.x, 2) + Math.pow(lbtr.y - btr.y, 2)) <= radius ||
				Math.sqrt(Math.pow(lbtr.x - btr.x, 2) + Math.pow(lbtr.y - btr.y, 2)) <= radius ||
				Math.sqrt(Math.pow(lbtr.x - btr.x, 2) + Math.pow(lbtr.y - btr.y, 2)) <= radius ||
				Math.sqrt(Math.pow(lbtr.x - btr.x, 2) + Math.pow(lbtr.y - btr.y, 2)) <= radius)
				return true;
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
		
	}
}