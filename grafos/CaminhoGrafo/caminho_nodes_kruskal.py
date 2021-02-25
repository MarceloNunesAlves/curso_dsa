# Algoritmo Kruskal para encontrar a Spanning Tree

# Imports
import priority_dict
from matriz import *


# Spanning Tree
def spanning_tree(graph):

	# Mantém um mapeamento de um par de arestas para o peso da aresta 
	# O peso da aresta é a prioridade da aresta
	priority_queue = priority_dict.priority_dict()

	for v in range(graph.numVertices):
		for neighbor in graph.get_adjacent_vertices(v):
			priority_queue[(v, neighbor)] = graph.get_edge_weight(v, neighbor)

	visited_vertices = set()

	# Mapeia um nó para todos os seus nós adjacentes, que estão na árvore mínima abrangente
	spanning_tree = {}
	for v in range(graph.numVertices):
		spanning_tree[v] = set()	

	# Número de arestas que chegamos até agora
	num_edges = 0

	while len(priority_queue.keys()) > 0 and num_edges < graph.numVertices - 1:
		v1, v2 = priority_queue.pop_smallest()

		if v1 in spanning_tree[v2]:
			continue


		# Organiza a árvore de expansão para que o nó com o identificador de vértice menor seja sempre o primeiro. 
		# Isso simplifica muito o código para encontrar ciclos nesta árvore.
		vertex_pair = sorted([v1, v2])
		spanning_tree[vertex_pair[0]].add(vertex_pair[1])

		# Verifica se a adição da aresta atual causa um ciclo
		if has_cycle(spanning_tree):
			spanning_tree[vertex_pair[0]].remove(vertex_pair[1])
			continue

		num_edges = num_edges + 1

		visited_vertices.add(v1)
		visited_vertices.add(v2)

	print("Vertices Visitados: ", visited_vertices)

	if len(visited_vertices) != graph.numVertices:
		print("Minimum spanning tree não encontrada")
	else:
		print("Minimum spanning tree:")
		for key in spanning_tree:
			for value in spanning_tree[key]:
				print(key, "-->", value)		


def has_cycle(spanning_tree):
	for source in spanning_tree:
		q = []
		q.append(source)

		visited_vertices = set()
		while len(q) > 0:
			vertex = q.pop(0)

			# Se vemos o vértice antes nesta árvore de expansão, há um ciclo
			if vertex in visited_vertices:
				return True
			visited_vertices.add(vertex)

			# Adiciona todos os vértices conectados por arestas nesta árvore de expansão
			q.extend(spanning_tree[vertex])

	return False		

# Grafo
g = AdjacencyMatrixGraph(8, directed=False)
g.add_edge(0, 1, 1)
g.add_edge(1, 2, 2)
g.add_edge(1, 3, 2)
g.add_edge(2, 3, 2)
g.add_edge(1, 4, 3)
g.add_edge(3, 5, 1)
g.add_edge(5, 4, 2)
g.add_edge(3, 6, 1)
g.add_edge(6, 7, 1)
g.add_edge(7, 0, 1)

# Spanning Tree
spanning_tree(g)








