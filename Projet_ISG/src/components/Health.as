package components 
{
	import com.ktm.genome.core.data.component.Component;
	
	public class Health extends Component {
		
		// Nombre de points de vie de l'entité
		public var currentPV:int = 100;
		
		// Nombre de points de vie à enlever à chaque cycle (si l'entité est infecté)
		public var lifeDecrement:int = 0;
		
		// Nombre de virus à ajouter au nombre total de virus qui pourront être produits à la mort de l'entité (si l'entité est infecté)
		public var numVirusIncrement:Number = 0;
		
		// Indique la fréquence des événements lifeDecrementation et numVirusIncrementation
		public var freq:int = 10;
		
		public var cpt:int = 0;
		
		public var id:String;
	}

}