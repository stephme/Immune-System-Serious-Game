package components 
{
	import com.ktm.genome.core.data.component.Component;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class SpecialisationLevel extends Component {
		
		public static const SPE_INCREMENT:Number = 0.5;
		public var virusSpecLevel:Number = 0;
		public var bacteriaSpecLevel:Number = 0;
		public var spec:int = SpecialisationEnum.NONE;
		public var addActionArea:Boolean = false;
		
	}

}