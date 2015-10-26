package components 
{
	import com.ktm.genome.core.data.component.Component;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class Parameters extends Component
	{
		// Nombre de points de vie à enlever à chaque cycle (si l'entité est infecté)
		public var lifeDecrement:int;
		
		// Nombre de virus à ajouter au nombre total de virus qui pourront être produits à la mort de l'entité (si l'entité est infecté)
		public var numVirusIncrement:int;
		
		// Indique la fréquence des événements lifeDecrementation et numVirusIncrementation
		public var freq:int;
		
	}

}