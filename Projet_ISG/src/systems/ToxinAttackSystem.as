package systems
{
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Layer;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.TargetPos;
	import com.ktm.genome.core.logic.system.System;
	import components.DeathCertificate;
	import components.Health;
	import components.SpecialisationLevel;
	import components.ToxinDamages;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class ToxinAttackSystem extends System {
		
		private var toxinEntities:Family;
		private var victimFamilies:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var toxinDamagesMapper:IComponentMapper;
		private var textureResourceMapper:IComponentMapper;
		private var nodeMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			toxinEntities = entityManager.getFamily(allOfGenes(ToxinDamages));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lympho T8
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lympho B
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL))); // cell
			
			// Définition des mappers
			transformMapper = geneManager.getComponentMapper(Transform);
			healthMapper = geneManager.getComponentMapper(Health);
			toxinDamagesMapper = geneManager.getComponentMapper(ToxinDamages);
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			nodeMapper = geneManager.getComponentMapper(Node);
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0; i < victimFamilies.length; i++) {
				for (var j:int = 0; j < victimFamilies[i].members.length; j++) {
					for (var h:int = 0; h < toxinEntities.members.length; h++) {
						var t:IEntity = toxinEntities.members[h];
						var td:ToxinDamages = toxinDamagesMapper.getComponent(t);
						if (deathCertificateMapper.getComponent(t).dead) continue;
						if (td.active) {
							var v:IEntity = victimFamilies[i].members[j];
							if (deathCertificateMapper.getComponent(v).dead) continue;
							if (toxinContact(t, v)) {
								var health:Health = healthMapper.getComponent(v);
								health.currentPV -= ToxinDamages.DAMAGES;
								trace(health.currentPV);
								var htr:Transform = transformMapper.getComponent(nodeMapper.getComponent(v).outNodes[0].entity);
								htr.scaleX = Number(health.currentPV) / 100;
								td.active = false;
								EntityFactory.killEntity(entityManager,t,transformMapper.getComponent(t));
							}
						}
					}
				}
			}
		}
		
		private function toxinContact(t:IEntity, v:IEntity):Boolean {
			var ttr:Transform = transformMapper.getComponent(t);
			var vtr:Transform = transformMapper.getComponent(v);
			if (Math.sqrt(Math.pow(ttr.x - vtr.x, 2) + Math.pow(ttr.y - vtr.y, 2)) <= 25 ||
				Math.sqrt(Math.pow((ttr.x+25) - vtr.x, 2) + Math.pow(ttr.y - vtr.y, 2)) <= 25 ||
				Math.sqrt(Math.pow(ttr.x - vtr.x, 2) + Math.pow((ttr.y+16) - vtr.y, 2)) <= 25 ||
				Math.sqrt(Math.pow((ttr.x+25) - vtr.x, 2) + Math.pow((ttr.y+16) - vtr.y, 2)) <= 25)
				return true;
			return false;
		}
		
	}

}