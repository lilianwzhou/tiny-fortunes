# Wednesday, June 30:

# https://leetcode.com/problems/invert-binary-tree/ 

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
class Solution:
    def invertTree(self, root: TreeNode) -> TreeNode:
        if root is None: 
            return None 
        temp = root.left
        root.left = root.right
        root.right = temp 
        self.invertTree(root.left)
        self.invertTree(root.right) 
        return root 
