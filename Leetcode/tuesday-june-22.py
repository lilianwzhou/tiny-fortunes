# Tuesday, June 22: 

# https://leetcode.com/problems/reverse-linked-list/

class ListNode:
     def __init__(self, val=0, next=None):
         self.val = val
         self.next = next

# O(n) space time + run time solution 

# class Solution:
#     def reverseList(self, head: ListNode) -> ListNode:
#         traverseNode = head
#         previoustemp = None
#         while traverseNode != None:
#             temp = ListNode(traverseNode.val)
#             temp.next = previoustemp
#             previoustemp = temp 
#             traverseNode = traverseNode.next 
#         return previoustemp


# O(1) space time + O(n) run time solution 

class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        temp = head
        previoustemp = None
        while temp != None: 
            next = temp.next
            temp.next = previoustemp
            previoustemp = temp 
            temp = next
        return previoustemp


# create linked list 1->2->3 
nodeOne = ListNode(1)
nodeTwo = ListNode(2)
nodeThree = ListNode(3)
nodeOne.next = nodeTwo
nodeTwo.next = nodeThree

# instance of the class that calls middleNode() with head being nodeOne
test = Solution().reverseList(nodeOne)

if test.val == 3 and test.next.val == 2 and test.next.next.val == 3: 
    print("Success for list 1->2->3")
else:
    print(f"We fucked up and got {test.val}")
    print(test)

