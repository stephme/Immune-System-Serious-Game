package
{
	import com.ktm.genome.game.manager.NodeManager;
	import com.ktm.genome.resource.entity.ExtendedXMLEntityBuilder;
	import com.ktm.genome.resource.entity.IEntityBuilder;
	import components.VirusTypeV;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import com.ktm.genome.core.IWorld;
	import com.ktm.genome.core.BigBang;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.core.logic.system.ISystemManager;
	import com.ktm.genome.core.logic.process.ProcessPhase;
	import com.ktm.genome.render.system.RenderSystem;
	import com.ktm.genome.resource.manager.ResourceManager;
	import com.lip6.genome.geography.move.system.MoveToSystem;
	import flash.events.MouseEvent;
	import systems.DeathCertificateSystem;
	import systems.HealthSystem;
	import systems.RandomMovingSystem;
	import systems.BacteriaRotationSystem;
	import systems.SpecialisationSystem;
	import systems.ToxinAttackSystem;
	import systems.ToxinProductionSystem;
	import systems.UserMovingSystem;
	import systems.VirusInfectionSystem;
	import systems.MacrophageAttackSystem;
	import systems.T8AttackSystem;
	
	public class Main extends Sprite {
		
		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {	
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var world:IWorld = BigBang.createWorld(stage);
			var sm:ISystemManager = world.getSystemManager();
			world.setLogic(NodeManager);
			world.setLogic(ExtendedXMLEntityBuilder, IEntityBuilder).strong();
			
			sm.setSystem(ResourceManager).setProcess(ProcessPhase.TICK, int.MAX_VALUE);
			sm.setSystem(MoveToSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(new RenderSystem(this)).setProcess(ProcessPhase.FRAME);
			
			sm.setSystem(new UserMovingSystem(stage)).setProcess(ProcessPhase.FRAME);
			//RotationSystem doit être avant RandomMovingSystem
			sm.setSystem(BacteriaRotationSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(RandomMovingSystem).setProcess(ProcessPhase.FRAME);
			
			sm.setSystem(MacrophageAttackSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(T8AttackSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(VirusInfectionSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(ToxinProductionSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(ToxinAttackSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(SpecialisationSystem).setProcess(ProcessPhase.FRAME);
			
			// TOUJOURS EN DERNIER
			sm.setSystem(HealthSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(DeathCertificateSystem).setProcess(ProcessPhase.FRAME);

			var gameURL:String = 'xml/game.entityBundle.xml';
			EntityFactory.createResourcedEntity(world.getEntityManager(), gameURL, "game");
		}
		
	}
	
}