package factory 
{
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.impl.Entity;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import components.Virus_Type;
	import components.TargetPos;
	
	public class Virus_Factory {
		
		public function Virus_Factory() {
			import com.ktm.genome.core.entity.IEntity;
			import com.ktm.genome.resource.component.EntityBundle;
			import com.ktm.genome.core.entity.IEntityManager;
			
			static public function createRessourcedEntity(em:IEntityManager, _source:String, _id:String):void {
				var e:IEntity = em.create();
				em.addComponent(e, EntityBundle, { source: _source, id: _id, toBuild: true } );
			}
			
			static public function createRessourcedEntity(em:IEntityManager, fields:Virus_Field):void {
				var e:IEntity = em.create();
				em.addComponent(e, Transform, fields.transform);
				em.addComponent(e, Layered, fields.layer);
				em.addComponent(e, TargetPos, fields.targetPos);
				em.addComponent(e, Virus_Type, fields.type);
			}
		}
	}
	
	class Virus_Field {
		public var transform:Object;
		public var layer:String;
		public var targetPos:Object;
		public var type:Virus_Type;
	}

}