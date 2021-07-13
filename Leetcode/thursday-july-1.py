# Thursday, July 1: 

# https://leetcode.com/problems/cousins-in-binary-tree/

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def isCousins(root: TreeNode, x: int, y: int) -> bool:
    current_level = set([root]) 
    while len(current_level) > 0: 
        next_level = set()
        for node in current_level: 
            if node.left != None and node.right != None: 
                if (node.left.val == x and node.right.val == y) or (node.left.val == y and node.right.val == x):
                    return False
            if node.left != None:
                next_level.add(node.left)
            if node.right != None:
                next_level.add(node.right)
        values = map(lambda x: x.val, next_level)
        if x in values and y in values: 
            return True
        elif x in values or y in values:
            return False 
        current_level = next_level
    return False

# tree example 1 
nodeOne = TreeNode(1)
nodeTwo = TreeNode(2)
nodeThree = TreeNode(3)
nodeFour = TreeNode(4)
nodeOne.left = nodeTwo
nodeOne.right = nodeThree
nodeTwo.left  = nodeFour 

print(isCousins(nodeOne, 3, 2))

