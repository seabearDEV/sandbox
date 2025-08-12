// Create a node using a simple factory function
function createNode(data) {
  return {
    data: data,
    next: null
  };
}

// Create a linked list
function createLinkedList() {
  let head = null;

  // Function to append nodes
  function append(data) {
    const newNode = createNode(data);

    if (!head) {
      head = newNode;
      return;
    }

    let current = head;
    while (current.next) {
      current = current.next;
    }
    current.next = newNode;
  }

  // Return the list operations
  return {
    append,
    getHead: () => head
  };
}

// Example usage
const list = createLinkedList();
list.append(1);

console.log(list);