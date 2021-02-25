# Dicionário Para a Fila Prioridades

from heapq import heapify, heappush, heappop

class priority_dict(dict):
    """Dicionário que pode ser usado como uma fila de prioridade.
     As chaves do dicionário são itens a serem colocados na fila e valores
     são as respectivas prioridades. Todos os métodos de dicionário funcionam como esperado.
     A vantagem em relação a uma fila de prioridade padrão baseada em heapq é
     que as prioridades dos itens podem ser atualizadas de forma eficiente (amortizado O (1))
    """
    
    def __init__(self, *args, **kwargs):
        super(priority_dict, self).__init__(*args, **kwargs)
        self._rebuild_heap()

    def _rebuild_heap(self):
        self._heap = [(v, k) for k, v in self.items()]
        heapify(self._heap)

    def smallest(self):
        """Retorne o item com a menor prioridade. Aumenta o IndexError se o objeto estiver vazio.
        """
        
        heap = self._heap
        v, k = heap[0]
        while k not in self or self[k] != v:
            heappop(heap)
            v, k = heap[0]
        return k

    def pop_smallest(self):
        """Devolva o item com a menor prioridade e remova-o. Gera IndexError se o objeto estiver vazio.
        """
        
        heap = self._heap
        v, k = heappop(heap)
        while k not in self or self[k] != v:
            v, k = heappop(heap)
        del self[k]
        return k

    def __setitem__(self, key, val):
        # Não vamos remover o valor anterior do heap, já que isso teria um custo O (n).
        
        super(priority_dict, self).__setitem__(key, val)
        
        if len(self._heap) < 2 * len(self):
            heappush(self._heap, (val, key))
        else:
            # Quando o heap cresce mais de 2 * len (self), reconstruí-lo do zero para evitar desperdiçar muita memória.
            self._rebuild_heap()

    def setdefault(self, key, val):
        if key not in self:
            self[key] = val
            return val
        return self[key]

    def update(self, *args, **kwargs):
        super(priority_dict, self).update(*args, **kwargs)
        self._rebuild_heap()

    def sorted_iter(self):
        """Ordenou o iterador dos itens do dicionário de prioridade. Cuidado: isso irá destruir os elementos conforme eles são devolvidos.
        """
        
        while self:
            yield self.pop_smallest()
