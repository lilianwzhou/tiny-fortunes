class Solution(object):
    def search(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: int
        """
        # recursive solution 
        if len(nums) == 0:
            return -1
        middle_index = len(nums)//2 
        left_list = nums[:middle_index]
        right_list = []
        if len(nums) > 1: 
            right_list = nums[middle_index + 1:]
        if target == nums[middle_index]:
            return middle_index
        elif target > nums[middle_index]:
            found_index = self.search(right_list, target)
            if found_index == -1: 
                return found_index
            return found_index + middle_index + 1
        else: 
            return self.search(left_list, target)


# example 1 

nums = [-1, 0, 3, 5, 9, 12]
target = 9

test = Solution().search(nums, target)
if test == 4: 
    print("success for ex 1")
else: 
    print(test)