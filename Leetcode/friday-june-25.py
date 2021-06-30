# Friday, June 25: 

# https://leetcode.com/problems/linked-list-cycle-ii/

class ListNode:
     def __init__(self, x):
         self.val = x
         self.next = None

class Solution:
    def detectCycle(self, head: ListNode) -> ListNode:
        if head is None:  # this is to
            return None
        slow = head
        fast = head #fix this one! 
        while fast != None and fast.next != None: #the and statement is to 
            slow = slow.next
            fast = fast.next.next #fix this! 
            if slow == fast:
                h2 = head
                temp = fast 
                while h2 != temp:
                    h2 = h2.next
                    temp = temp.next
                return h2 
        return None 


# create list 3->2->0->-4 with link from -4 to 2
nodeOne = ListNode(3)
nodeTwo = ListNode(2)
nodeThree = ListNode(0)
nodeFour = ListNode(-4)
nodeOne.next = nodeTwo
nodeTwo.next = nodeThree
nodeThree.next = nodeFour
nodeFour.next = nodeTwo

test = Solution().detectCycle(nodeOne)

if test.val == 2: 
    print("Success for list 3->2->0->-4 with link from -4 to 2")
else:
    print(f"We fucked up and got {test.val}")
    print(test)
