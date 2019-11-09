# kmeans
 k-means clustering demo for Processing

https://en.wikipedia.org/wiki/K-means_clustering

You want to group points into N clusters.

make N cluster centers.
do {
	for all points {
	  find nearest cluster center
	}

	error = 0
	for all clusters {
		oldCenter = this cluster center position
		newCenter = 0
		j = 0
		for all points P in this cluster {
			newCenter += P positon
			j++
		}
		newCenter /= j;
		error += newCenter - oldCenter;
	}
} while( error > some small value)