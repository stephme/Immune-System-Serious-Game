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
	/**
	 * ...
	 * @author Stéphane
	 */
	public class ToxinAttackSystem extends System {
		
		public static const TOXIN_DAMAGES:int = 10;
		
		private var toxinEntities:Family;
		private var victimFamilies:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var nodeMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			toxinEntities = entityManager.getFamily(allOfFlags(Flag.TOXIN));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lympho T8
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lympho B
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL))); // cell
			
			// Définition des mappers
			transformMapper = geneManager.getComponentMapper(Transform);
			healthMapper = geneManager.getComponentMapper(Health);
			nodeMapper = geneManager.getComponentMapper(Node);
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var h:int = 0; h < toxinEntities.members.length; h++) {
				var t:IEntity = toxinEntities.members[h];
				var dc:DeathCertificate = deathCertificateMapper.getComponent(t);
				if (dc.dead) continue;
				for (var i:int = 0; i < victimFamilies.length; i++) {
					for (var j:int = 0; j < victimFamilies[i].members.length; j++) {
						var v:IEntity = victimFamilies[i].members[j];
						if (deathCertificateMapper.getComponent(v).dead) continue;
						if (Contact.toxinContact(transformMapper.getComponent(t), transformMapper.getComponent(v))) {
							var health:Health = healthMapper.getComponent(v);
							health.currentPV -= TOXIN_DAMAGES;
							HealthSystem.updateHealthBar(transformMapper.getComponent(nodeMapper.getComponent(v).outNodes[0].entity), health);
							
							trace("bactery is killed");
							dc.dead = true;
						}
					}
				}
			}
		}
		
	}

}