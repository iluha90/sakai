package org.sakaiproject.gradebookng.tool.panels;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.wicket.AttributeModifier;
import org.apache.wicket.ajax.AjaxRequestTarget;
import org.apache.wicket.ajax.markup.html.AjaxLink;
import org.apache.wicket.extensions.ajax.markup.html.modal.ModalWindow;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.panel.Panel;
import org.apache.wicket.model.IModel;
import org.apache.wicket.model.Model;
import org.sakaiproject.gradebookng.business.model.GbStudentNameSortOrder;
import org.sakaiproject.gradebookng.tool.pages.GradebookPage;

/**
 * 
 * Cell panel for the students average score in a category
 * 
 * @author Steve Swinsburg (steve.swinsburg@gmail.com)
 *
 */
public class CategoryColumnCellPanel extends Panel {

	private static final long serialVersionUID = 1L;
		
	IModel<Map<String,Object>> model;

	public CategoryColumnCellPanel(String id, IModel<Map<String,Object>> model) {
		super(id, model);
		this.model = model;
	}
	
	@Override
	public void onInitialize() {
		super.onInitialize();
		
		//unpack model
		Map<String,Object> modelData = (Map<String,Object>) this.model.getObject();
		String score = (String) modelData.get("score");		
		
		//score label
		add(new Label("score", getCategoryScore(score)));
		
		//accessibility
		getParent().add(new AttributeModifier("scope", "row"));
		getParent().add(new AttributeModifier("role", "rowheader"));

	}
	
	
	/**
	 * Helper to format a category score
	 * 
	 * The value is a double type string (ie 12.34) that needs to be formatted as a percentage.
	 * If null, it should return N/A or equivalent.
	 * 
	 * @param score
	 * @return 12.34% type string or N/A
	 */
	private String getCategoryScore(String score) {
		
		if(StringUtils.isBlank(score)){
			return getString("label.nocategoryscore");
		}
		
		return getString("label.categoryscore", Model.of(score));
	}
	
	
	
}
