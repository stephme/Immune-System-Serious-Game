package components 
{
	import com.ktm.genome.core.data.component.Component;
	
	public class Health extends Component {
		
		// Nombre de points de vie de l'entité
		public var currentPV:int = 100;
		
		// Indique la fréquence des événements lifeDecrementation et numVirusIncrementation
		public var freq:int = 100;
		
		public var cpt:int = 0;
		
		public var id:String;
	}

}