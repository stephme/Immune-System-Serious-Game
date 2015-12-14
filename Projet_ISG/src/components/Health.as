package components 
{
	import com.ktm.genome.core.data.component.Component;
	
	public class Health extends Component {
		
		public var currentPV:int = 100;
		public var delta:Number = 0.7;
		public var cpt:Number = 0;
	
	}

}