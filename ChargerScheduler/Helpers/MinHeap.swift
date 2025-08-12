//
//  MinHeap.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 11/08/25.
//

import Foundation

struct MinHeap<T: Comparable> {
    private var elements: [T] = []
    
    var isEmpty: Bool {
        elements.isEmpty
    }
    
    var count: Int {
        elements.count
    }
    
    var peek: T? {
        elements.first
    }
    
    //MARK: - Heap operations
    
    mutating func insert(_ element: T) {
        elements.append(element)
        heapifyUp(from: elements.count - 1)
    }
    
    @discardableResult
    mutating func extractMin() -> T? {
        guard !elements.isEmpty else { return nil }
        
        if elements.count == 1 {
            return elements.removeLast()
        }
        
        let min = elements.first // First element will be the minimum element always, due to the structure of Minheap - O(1) time complexity
        elements[0] = elements.removeLast() // Put the last element to the roor temporarily, to re adjust the elements size after the minimum element is extracted - O(1) time complexity
        heapifyDown(from: 0) // Ensures that the min-heap property is maintained after the removal of the minimum element - O(log n)
        return min
    }
    
    mutating func update<U>(_ element: T, with newValue: U, using keypath: WritableKeyPath<T, U>) {
        if let index = elements.firstIndex(of: element) {
            elements[index][keyPath: keypath] = newValue
            heapifyUp(from: index)
            heapifyDown(from: index)
        }
    }
    
    // MARK: - Private helper methods
    
    private mutating func heapifyUp(from index: Int) {
        var childIndex = index
        let child = elements[childIndex]
        var parentIndex = self.parentIndex(of: childIndex)
        
        while (childIndex > 0) && (elements[childIndex] < elements[parentIndex]) {
            elements[childIndex] = elements[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(of: childIndex)
        }
    }
    
    private mutating func heapifyDown(from index: Int) {
        var parentIndex = index
        
        while true {
            var leftChildIndex = self.leftChildIndex(of: parentIndex)
            var rightChildIndex = self.rightChildIndex(of: parentIndex)
            var candidateIndex = parentIndex
            
            if leftChildIndex < elements.count && elements[leftChildIndex] < elements[candidateIndex] {
                candidateIndex = leftChildIndex
            }
            
            if rightChildIndex < elements.count && elements[rightChildIndex] < elements[candidateIndex] {
                candidateIndex = rightChildIndex
            }
            
            if candidateIndex == parentIndex {
                break // Heap property is satisfied
            }
            
            elements.swapAt(parentIndex, candidateIndex)
            parentIndex = candidateIndex
        }
    }
    
    // MARK: - Index calculations
    
    private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    
    private func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }
    
    private func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }
}
