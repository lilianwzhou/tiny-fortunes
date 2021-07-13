# Friday, July 2: 

# https://leetcode.com/problems/maximum-binary-tree/

class TreeNode(object):
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
class Solution(object):
    def constructMaximumBinaryTree(self, nums):
        if nums == []:
            return None
        current_max = 0
        max_index = 0
        for i in range(len(nums)): 
            if nums[i] > current_max: 
                current_max = nums[i] 
                max_index = i 
        root = TreeNode(current_max)
        root.left = self.constructMaximumBinaryTree(nums[0: max_index])
        if max_index < len(nums) - 1: 
            root.right = self.constructMaximumBinaryTree(nums[max_index+1:]) 
        return root 

# example 2 

nums = [3, 2, 1]

root = Solution().constructMaximumBinaryTree(nums)

if root.right.val == 2 and root.left is None and root.right.right.val == 1 and root.right.left is None:
    print("yay!")
else:
    print(f'Failed {root}') # i think? failed root
