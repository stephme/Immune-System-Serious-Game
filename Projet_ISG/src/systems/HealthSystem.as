package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Layer;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
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
		private var textureResourceMapper:IComponentMapper;
		private var layeredMapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var VirusTypeAMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			entities = entityManager.getFamily(allOfGenes(Health,DeathCertificate));
			
			nodeMapper = geneManager.getComponentMapper(Node);
			healthMapper = geneManager.getComponentMapper(Health);
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			layeredMapper = geneManager.getComponentMapper(Layered);
			layerMapper = geneManager.getComponentMapper(Layer);
			transformMapper = geneManager.getComponentMapper(Transform);
			VirusTypeAMapper = geneManager.getComponentMapper(VirusTypeA);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0; i < entities.members.length; i++) {
				var e:IEntity = entities.members[i];
				if (deathCertificateMapper.getComponent(e).dead) continue;
				var deathCerti:DeathCertificate = deathCertificateMapper.getComponent(e);
				if (deathCerti.dead) continue;
				var h:Health = healthMapper.getComponent(e);
				var n:Node = nodeMapper.getComponent(e);
				var victimVt:VirusTypeA = VirusTypeAMapper.getComponent(e);
				if (victimVt != null && ++h.cpt == h.freq) {
					h.currentPV -= victimVt.effectiveness;
					deathCerti.infected += victimVt.propagation;
					h.cpt = 0;
					updateHealth(n, h, victimVt);
				}
				if (h.currentPV <= 0)
					deathCerti.dead = true;
			}
		}
		
		private function updateHealth(n:Node, h:Health, victimVt:VirusTypeA):void {
			var healthBar:IEntity = n.outNodes[0].entity;
			var htr:Transform = transformMapper.getComponent(healthBar);
			htr.scaleX = Number(h.currentPV) / 100;
		}
		
	}

}