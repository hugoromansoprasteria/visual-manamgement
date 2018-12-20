class Dashing.Gantt extends Dashing.Widget

	@accessor 'title', ->
		titre = @get('project_title')
		console.log("TITRE project_title: " + titre)
		if titre == "('ALL')"
			titre = @get('bundle_title')
			console.log("TITRE bundle_title: " + titre)
		if(titre?)
			longueur = (titre.length)-2
			title = titre.substr(1, longueur).split("'").join("")
		else
			title = "Dashboard not set. Update config file. Or wait the next refresh"
		
	@accessor 'task_id', ->
		titre = @get('project_title')
		arr = @get('mydata')
		for key, value of arr
			if titre == "('ALL')"
				value.project + " : " + value.program + " : "+ value.name
			else
				value.program + " : " + value.name

	@accessor 'task_dates_start', ->

		arr = @get('mydata')
		for key, value of arr 
			value.start

	@accessor 'task_dates_end', ->

		arr = @get('mydata')
		for key, value of arr 
			value.end

	@accessor 'task_dates_progress', ->

		arr = @get('mydata')
		for key, value of arr 
			value.progress

	@accessor 'program_name', ->
		titre = @get('project_title')
		arr = @get('mydata')
		for key, value of arr
			if titre == "('ALL')"
				value.project
			else
				value.program