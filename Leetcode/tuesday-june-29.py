# Tuesday, June 29: 

# https://leetcode.com/problems/maximum-depth-of-binary-tree/

class TreeNode:
     def __init__(self, val=0, left=None, right=None):
         self.val = val
         self.left = left
         self.right = right
class Solution:
    def maxDepth(self, root: TreeNode) -> int:
        if root is None: 
            return 0 
        left_child = self.maxDepth(root.left)
        right_child = self.maxDepth(root.right)
        return max(left_child, right_child) + 1 


# create tree ex 1
nodeOne = TreeNode(3)
nodeTwo = TreeNode(9)
nodeThree = TreeNode(20)
nodeFour = TreeNode(15)
nodeFive = TreeNode(7)
nodeOne.left = nodeTwo
nodeOne.right = nodeThree
nodeThree.left = nodeFour
nodeThree.right = nodeFive 

test = Solution().maxDepth(nodeOne)

if test == 3:
    print("Success for tree ex 1")
else:
    print(f'Failed {test}')

#create tree with one node 
nodeOne = TreeNode(1)

test = Solution().maxDepth(nodeOne)

if test == 1:
    print("Success for tree with one node")
else:
    print(f'Failed {test}')
