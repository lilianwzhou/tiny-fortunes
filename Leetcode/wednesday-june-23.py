# Wednesday, June 23: 

# https://leetcode.com/problems/remove-duplicates-from-sorted-list/ 

class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
class Solution:
    def deleteDuplicates(self, head: ListNode) -> ListNode:
        current = head
        while current != None: 
            if current.next != None and current.val == current.next.val: 
                next = current.next.next
                current.next.next = None
                current.next = next 
            else: 
                current = current.next 
        return head 
        

# create linked list 1->1->2
nodeOne = ListNode(1)
nodeOneDuplicate = ListNode(1)
nodeTwo = ListNode(2)
nodeOne.next = nodeOneDuplicate
nodeOneDuplicate.next = nodeTwo

# instance of the class that calls middleNode() with head being nodeOne
test = Solution().deleteDuplicates(nodeOne)

if test.val == 1 and test.next.val == 2:
    print("Success for list 1->1->2")
else:
    print(f"We fucked up and got {test.val}")
    print(test)

# empty linked list!
empty_test = Solution().deleteDuplicates(None)
if empty_test is None:
    print("Success for empty test")
else:
    print("fail")

# one element linked list 1
test = Solution().deleteDuplicates(ListNode(1))
if test.val == 1:
    print("Success for one element list")
else:
    print(f"We fucked up and got {test.val}")
    print(test)

# 1->1
# 1->2 

# create linked list 1->1->1 !!!!!!!!! 
nodeOne = ListNode(1)
nodeOneDuplicate = ListNode(1)
nodeOneTriple = ListNode(1) 
nodeOne.next = nodeOneDuplicate
nodeOneDuplicate.next = nodeOneTriple

test = Solution().deleteDuplicates(nodeOne)

if test.val == 1:
    print("Success for list 1->1->1")
else:
    print(f"We fucked up and got {test.val}")
    print(test)
