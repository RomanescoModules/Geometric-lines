class GeometricLines extends g.PrecisePath
	@rname = 'Geometric lines'
	@rdescription = "Draws a line between pair of points which are close enough."
	@iconURL = 'static/images/icons/inverted/links.png'
	@iconAlt = 'links'

	@parameters: ()->
		parameters = super()
		# override the default color function, since we get better results with a very transparent color
		parameters['Style'].strokeColor.defaultFunction = null
		parameters['Style'].strokeColor.default = "rgba(39, 158, 224, 0.21)"
		delete parameters['Style'].fillColor 	# remove the fill color, we do not need it

		parameters['Parameters'] ?= {}
		parameters['Parameters'].step =
			type: 'slider'
			label: 'Step'
			min: 5
			max: 100
			default: 11
			simplified: 20
			step: 1
		parameters['Parameters'].distance = 	# the maximum distance between two linked points
			type: 'slider'
			label: 'Distance'
			min: 5
			max: 250
			default: 150
			simplified: 100

		return parameters

	beginDraw: ()->
		@initializeDrawing(true)
		@points = [] 							# will contain the points to check distances
		return

	updateDraw: (offset, step)->
		if not step then return

		point = @controlPath.getPointAt(offset)
		normal = @controlPath.getNormalAt(offset).normalize()

		point = @projectToRaster(point) 		#  convert the points from project to canvas coordinates
		@points.push(point)

		distMax = @data.distance*@data.distance

		# for all points: check if current point is close enough
		for pt in @points

			if point.getDistance(pt, true) < distMax 	# if points are close enough: draw a line between them
				@context.beginPath()
				@context.moveTo(point.x,point.y)
				@context.lineTo(pt.x,pt.y)
				@context.stroke()

		return

	endDraw: ()->
		return

tool = new g.PathTool(GeometricLines, true)