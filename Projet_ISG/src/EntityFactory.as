package 
{
	import com.ktm.genome.core.data.component.Component;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.EntityBundle;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.Speed;
	import com.lip6.genome.geography.move.component.TargetPos;
	import components.Agglutined;
	import components.DeathCertificate;
	import components.ToxinDamages;
	import components.VirusTypeV;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class EntityFactory 
	{
		public static const LOW_SPEED:Number = 0.1;
		public static const MED_SPEED:Number = 0.3;
		public static const HIGH_SPEED:Number = 0.7;

		static public function createResourcedEntity(em:IEntityManager,_source:String,_id:String):void {
			// Création d’une entité vide
			var e:IEntity = em.create();
			// Ajout du composant EntityBundle à cette entité et initialisation de ces trois propriétés : source, id et toBuild.
			em.addComponent(e, EntityBundle, {source:_source,id:_id, toBuild: true});
		}
		
		static public function createWasteEntity(em:IEntityManager, x:Number, y:Number):void {
			var e:IEntity = em.create();
			e.flags = Flag.WASTE;
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
			em.addComponent(e, Speed, { velocity: LOW_SPEED } );
			em.addComponent(e, TargetPos, { x:x, y:y } );
			em.addComponent(e, DeathCertificate, {dead:false, infected:-1, wasted:-1, active:true});
		}
		
		static public function createToxinEntity(em:IEntityManager, x:Number, y:Number):void {
			var e:IEntity = em.create();
			em.addComponent(e, Transform, { x:x, y:y } );
			em.addComponent(e, TextureResource, { source: "pictures/toxin.png", id : "toxine" } );
			em.addComponent(e, Layered, { layerId: "gameLayer" } );
			em.addComponent(e, Speed, { velocity: MED_SPEED } );
			em.addComponent(e, TargetPos, { x:x, y:y } );
			em.addComponent(e, ToxinDamages, { active:true } );
			em.addComponent(e, DeathCertificate, {dead:false, infected:-1, wasted:-1, active:true});
		}
		
		static public function createVirusEntity(em:IEntityManager, fields:Virus_Field):void {
			var e:IEntity = em.create();
			em.addComponent(e, Transform, fields.transform);
			em.addComponent(e, TextureResource, { source: "pictures/virus.png", id : "virus" } );
			em.addComponent(e, Layered, { layerId: "gameLayer" } );
			em.addComponent(e, Speed, { velocity: MED_SPEED } );
			em.addComponent(e, TargetPos, fields.targetPos);
			em.addComponent(e, VirusTypeV, fields.type);
			em.addComponent(e, Agglutined, {agglu : false});
			em.addComponent(e, DeathCertificate, {dead:false, infected:-1, wasted:-1, active:true});
		}
		
		static public function createSelectionCircleEntity(em:IEntityManager, layerId:String, x:Number, y:Number):IEntity {
			var e:IEntity = em.create();
			em.addComponent(e, Transform, { x:x, y:y } );
			em.addComponent(e, TextureResource, { source: "pictures/selection.png", id : "selection" } );
			em.addComponent(e, Layered, { layerId: layerId } );
			em.addComponent(e, Node);
			return e;
		}
		
		static public function createPlaceHolderEntity(em:IEntityManager, obj:Object):IEntity {
			var e:IEntity = em.create();
			trace(obj);
			trace(e);
			em.addComponent(e, Transform, { x : obj.x, y : obj.y, rotation : obj.rotation } );
			em.addComponent(e, TextureResource, { source : obj.source, id : obj.id} );
			em.addComponent(e, Layered, { layerId : "gameLayer" } );
			return e;
		}
		
		static public function killEntity(em:IEntityManager, t:IEntity, ttr:Transform):void {
			var pas:Number = 0.1;
			var tim:Timer = new Timer(100, 1 / pas);
			tim.addEventListener(TimerEvent.TIMER, fadeOut(ttr, pas));
			function fadeOut(ttr:Transform, pas:Number):Function {
				return function():void {
					ttr.alpha -= pas;
				}
			}

			tim.addEventListener(TimerEvent.TIMER_COMPLETE, kill(t));
			function kill(t:IEntity):Function {
				return function():void {
					em.killEntity(t);
				}
			}
			tim.start();
		}
	}
}