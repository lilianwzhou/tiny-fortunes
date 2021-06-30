# Monday, June 28: 

# https://leetcode.com/problems/binary-tree-inorder-traversal/

class TreeNode:
     def __init__(self, val=0, left=None, right=None):
         self.val = val
         self.left = left
         self.right = right
class Solution:
    def inorderTraversal(self, root: TreeNode) -> List[int]:
        if root is None: 
            return []
        left_list = self.inorderTraversal(root.left)
        left_list.append(root.val)
        right_list = self.inorderTraversal(root.right) 
        return left_list + right_list 


# create tree ex 1
nodeOne = TreeNode(1)
nodeTwo = TreeNode(2) 
nodeThree = TreeNode(3) 
nodeOne.right = nodeTwo
nodeTwo.left = nodeThree

test = Solution().inorderTraversal(nodeOne) 

if test == [1, 3, 2]: 
    print("Success for tree ex 1")
else: 
    print(f'Failed {test}') 