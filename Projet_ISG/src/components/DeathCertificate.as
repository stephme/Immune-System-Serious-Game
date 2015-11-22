package components 
{
	import com.ktm.genome.core.data.component.Component;
	
	public class DeathCertificate extends Component {
		public var dead:Boolean = false;
		public var infected:Number = 0;
		public var wasted:int = 0;
		public var active:Boolean = true;
	}
}