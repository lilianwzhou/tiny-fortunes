# Thursday, June 24: 

# https://leetcode.com/problems/linked-list-cycle/

class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

# O(n) space and run time 

# class Solution:
#     def hasCycle(self, head: ListNode) -> bool:
#         s = set()
#         current = head 
#         while current != None: 
#             if current in s: 
#                 return True
#             else: 
#                 s.add(current)
#                 current = current.next 
#         return False 

# O(1) space and O(n) run time 

class Solution:
    def hasCycle(self, head: ListNode) -> bool:
        if head is None: #this is to 
            return False 
        slow = head
        fast = head.next #fix this one! 
        while fast != None and fast.next != None: #the and statement is to 
            if slow == fast:
                return True
            slow = slow.next 
            fast = fast.next.next #fix this! 
        return False 

# create list 3->2->0->-4 with link from -4 to 2 
nodeOne = ListNode(3)
nodeTwo = ListNode(2)
nodeThree = ListNode(0)
nodeFour = ListNode(-4)
nodeOne.next = nodeTwo
nodeTwo.next = nodeThree
nodeThree.next = nodeFour
nodeFour.next = nodeTwo 

test = Solution().hasCycle(nodeOne) 

if test is True: 
    print("Success for list 3->2->0->-4 with link from -4 to 2")
else: 
    print(f"We fucked up and got {test.val}")
    print(test)

# create list 1->2->3->4 (no cycle)
nodeOne = ListNode(1)
nodeTwo = ListNode(2)
nodeThree = ListNode(3)
nodeFour = ListNode(4)
nodeOne.next = nodeTwo
nodeTwo.next = nodeThree
nodeThree.next = nodeFour

test = Solution().hasCycle(nodeOne)

if test is False: 
    print("Success for list 1->2->3->4 (no cycle)")
else: 
    print(f"We fucked up and got {test.val}")
    print(test)
