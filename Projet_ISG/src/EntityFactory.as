package 
{
	
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.EntityBundle;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.Speed;
	import com.lip6.genome.geography.move.component.TargetPos;
	
	public class EntityFactory 
	{
		

		static public function createResourcedEntity(em:IEntityManager,_source:String,_id:String):void {
			// Création d’une entité vide
			var e:IEntity = em.create();
			// Ajout du composant EntityBundle à cette entité et initialisation de ces trois propriétés : source, id et toBuild.
			em.addComponent(e, EntityBundle, {source:_source,id:_id, toBuild: true});
		}
		
		static public function createDechetEntity(em:IEntityManager, x:int, y:int, velocity:Number):void {
			var e:IEntity = em.create();
			em.addComponent(e, Transform, { x:x, y:y } );
			var val:int = 3 * Math.random();
			var filename:String;
			if (val == 0)
				filename = "pictures/waste1.png";
			else if (val == 1)
				filename = "pictures/waste2.png";
			else
				filename = "pictures/waste3.png";
			em.addComponent(e, TextureResource, { source: filename, id : "dechet" + (++val) } );
			em.addComponent(e, Layered, { layerId: "gameLayer" } );
			em.addComponent(e, Speed, { velocity: velocity } );
			em.addComponent(e, TargetPos, { x:x, y:y } );
		}
		
	}

}