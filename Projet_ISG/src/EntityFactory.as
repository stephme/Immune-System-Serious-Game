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
	import components.Virus_Type;
	
	public class EntityFactory 
	{
		
		public static const LOW_SPEED:Number = 0.2;
		public static const MED_SPEED:Number = 1;
		public static const HIGH_SPEED:Number = 3;

		static public function createResourcedEntity(em:IEntityManager,_source:String,_id:String):void {
			// Création d’une entité vide
			var e:IEntity = em.create();
			// Ajout du composant EntityBundle à cette entité et initialisation de ces trois propriétés : source, id et toBuild.
			em.addComponent(e, EntityBundle, {source:_source,id:_id, toBuild: true});
		}
		
		static public function createWasteEntity(em:IEntityManager, x:Number, y:Number):void {
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
			em.addComponent(e, Speed, { velocity: MED_SPEED } );
			em.addComponent(e, TargetPos, { x:x, y:y } );
		}
		
		static public function createToxinEntity(em:IEntityManager, x:Number, y:Number):void {
			var e:IEntity = em.create();
			em.addComponent(e, Transform, { x:x, y:y } );
			em.addComponent(e, TextureResource, { source: "pictures/toxin.png", id : "toxine" } );
			em.addComponent(e, Layered, { layerId: "gameLayer" } );
			em.addComponent(e, Speed, { velocity: MED_SPEED } );
			em.addComponent(e, TargetPos, { x:x, y:y } );
			e.flags = Flag.TOXIN;
		}
		
		static public function createVirusEntity(em:IEntityManager, fields:Virus_Field):void {
			var e:IEntity = em.create();
			em.addComponent(e, Transform, fields.transform);
			em.addComponent(e, Layered, "gameLayer");
			em.addComponent(e, TargetPos, fields.targetPos);
			em.addComponent(e, Virus_Type, fields.type);
		}
		
	}

}