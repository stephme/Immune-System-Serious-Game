package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Transform;
	import components.DeathCertificate;
	import components.ToxinProduction;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class ToxinProductionSystem extends System {
		
		private var bacteriaEntities:Family;
		private var transformMapper:IComponentMapper;
		private var toxinProductionMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		private var nodeMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			bacteriaEntities = entityManager.getFamily(allOfGenes(ToxinProduction));
			
			// Définition des mappers
			toxinProductionMapper = geneManager.getComponentMapper(ToxinProduction);
			transformMapper = geneManager.getComponentMapper(Transform);
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
			nodeMapper = geneManager.getComponentMapper(Node);
		}
		
		/*
		 * Chaque bactérie génère une toxine toutes les N frames (N étant la valeur de la variable freq du composant ToxinProduction 
		 * de l'entité)
		 */
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0 ; i < bacteriaEntities.members.length ; i++) {
				var e:IEntity = bacteriaEntities.members[i];
				if (deathCertificateMapper.getComponent(e).dead) continue;
				var tp:ToxinProduction = toxinProductionMapper.getComponent(e);
				if (++tp.cpt == tp.freq) {
					var tr:Transform = transformMapper.getComponent(e);
					var _tr:Transform = transformMapper.getComponent(nodeMapper.getComponent(e).outNodes[1].entity);
					EntityFactory.createToxinEntity(entityManager, tr.x + _tr.x, tr.y + _tr.y);
					tp.cpt = 0;
				}
			}
		}
		
	}

}