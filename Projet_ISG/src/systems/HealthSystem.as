package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Transform;
	import components.VirusTypeA;
	import components.DeathCertificate;
	import components.Health;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class HealthSystem extends System {
		
		private var entities:Family;
		
		private var nodeMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var virusTypeAMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			entities = entityManager.getFamily(allOfGenes(Health,DeathCertificate));
			
			nodeMapper = geneManager.getComponentMapper(Node);
			healthMapper = geneManager.getComponentMapper(Health);
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
			transformMapper = geneManager.getComponentMapper(Transform);
			virusTypeAMapper = geneManager.getComponentMapper(VirusTypeA);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0; i < entities.members.length; i++) {
				var e:IEntity = entities.members[i];
				var deathCerti:DeathCertificate = deathCertificateMapper.getComponent(e);
				if (deathCerti.dead) continue;
				var h:Health = healthMapper.getComponent(e);
				var victimVt:VirusTypeA = virusTypeAMapper.getComponent(e);
				if (victimVt != null) {
					h.cpt += delta / 1000;
					if (h.cpt >= h.delta) {
						h.currentPV -= victimVt.effectiveness;
						deathCerti.infected += victimVt.propagation;
						h.cpt = 0;
						updateHealthBar(transformMapper.getComponent(nodeMapper.getComponent(e).outNodes[0].entity), h);
					}
				}
				if (h.currentPV <= 0)
					deathCerti.dead = true;
			}
		}
		
		public static function updateHealthBar(trHealthBar:Transform, h:Health):void {
			trHealthBar.scaleX = Number(h.currentPV) / 100;
		}
		
	}

}