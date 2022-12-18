# java 算法题

## 数组

### 从排序数组中删除重复项

给定一个排序数组，你需要在**原地**删除重复出现的元素，使得每个元素只出现一次，返回移除后数组的新长度。

不要使用额外的数组空间，你必须在**原地修改输入数组**并在使用 O(1) 额外空间的条件下完成。

```java
class Solution {
    // 1 1 2
    // 0 0 1 1 1 2 2 3 3 4
    public int removeDuplicates(int[] nums) {
          if (nums.length == 0) {
            return 0;
        }
        int slow = 0;
        for (int i = 1; i < nums.length; i++) {
            if (nums[slow] != nums[i]) {
                nums[++slow] = nums[i];
            }
        }
        return slow + 1;
    }
}
```

最快解法

```java
  if(nums.length <= 1){
            return nums.length;
        }
        //慢指针
        int slow = 0;
        for(int fast = 1; fast < nums.length; fast++){
            if(nums[fast] != nums[slow]){
                slow++;
                nums[slow] = nums[fast];
            }
        }
        return slow + 1;
```



### 买卖股票的最佳时机 II

给定一个数组，它的第 *i* 个元素是一支给定股票第 *i* 天的价格。

设计一个算法来计算你所能获取的最大利润。你可以尽可能地完成更多的交易（多次买卖一支股票）。

**注意：**你不能同时参与多笔交易（你必须在再次购买前出售掉之前的股票）。

```java
class Solution {
    public int maxProfit(int[] prices) {
        
        int i=0,j=1;
        int interst = 0;
        if (prices == null || prices.length==0){
            return 0;
        }else{
            while (prices.length != j){
		//下坡
	    if (prices[i]>prices[j]){
	        i++;
	        j++;
        }else {
	    	//上坡
            //爬到山顶卖出
			if (j==prices.length-1){
				interst = prices[j] - prices[i] + interst;
				break;
			}
			j++;
			//山谷卖出
			if (prices[j-1]>prices[j] ){
					interst = prices[j-1]-prices[i]+interst;
					i =j;
					//如果是最后一点不用加
					if (j!=prices.length-1){
						j++;
					}

			}
			


        }
    }
        }
        return interst;
    }
}
```

### 旋转数组

给定一个数组，将数组中的元素向右移动 *k* 个位置，其中 *k* 是非负数。

1.  [1,2,3,4,5,6,7] , k = 3 -------->   [5,6,7,1,2,3,4]

```java
/**
     * 翻转
     * 时间复杂度：O(n)
     * 空间复杂度：O(1)
     */
/**
第一步
[1,2,3,4,5,6,7] --->  [7,6,5,4,3,2,1]
第二步 k = k % n  然后 k 前倒序 k 后倒序
[7,6,5,4,3,2,1] --->  [5,6,7,1,2,3,4]
*/
    public void rotate_2(int[] nums, int k) {
        int n = nums.length;
        k %= n;
        reverse(nums, 0, n - 1);
        reverse(nums, 0, k - 1);
        reverse(nums, k, n - 1);
    }
    private void reverse(int[] nums, int start, int end) {
        while (start < end) {
            int temp = nums[start];
            nums[start++] = nums[end];
            nums[end--] = temp;
        }
    }
```

### 存在重复

给定一个整数数组，判断是否存在重复元素。

如果任何值在数组中出现至少两次，函数返回 true。如果数组中每个元素都不相同，则返回 false。

```java
class Solution {
    public boolean containsDuplicate(int[] nums) {
        HashMap map = new HashMap();
        for(int i=0;i<nums.length;i++){
            if(map.containsKey(nums[i])){
                return true;
            }
            map.put(nums[i], 0);
        }
        return false;
    }
}
```

最快解法

```java
   for (int i = 1; i < nums.length; i++) {
       for (int j = i - 1; j >= 0; j--) {
           if (nums[i] > nums[j]) {
               break;
           } else if (nums[i] == nums[j]) {
               return true;
           }
       }

   }
   return false;
```

### 只出现一次的数字

给定一个**非空**整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。

**说明：**

你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？

解法一: 使用异或

```java
class Solution {
    public int singleNumber(int[] nums) {
        int temp = nums[0];
        for(int i = 1;i<nums.length;i++){
            temp ^= nums[i];
        }
        return temp;
    }
}
```

我的解法:

```java
class Solution {
    public int singleNumber(int[] nums) {
        HashMap<Integer,Integer> map = new HashMap();
        if (nums.length == 0){
            return 0;
        }
        //统计
        for(int i=0;i<nums.length;i++){
            if(map.containsKey(nums[i])){
                int count = map.get(nums[i]) + 1;
                map.put(nums[i],count);
            }else {
                map.put(nums[i],0);
            }
        }
        //查找
        for (HashMap.Entry<Integer, Integer> entry : map.entrySet()) {
            if (entry.getValue() == 0){
                return entry.getKey();
            }
        }
        return 0;
    }
}
```

### 两个数组的交集 II

给定两个数组，编写一个函数来计算它们的交集。

最快解法

```java
class Solution {
   public static int[] intersect(int[] nums1, int[] nums2) {
		 if(nums1==null || nums2==null) return null;
        Arrays.sort(nums1);
        Arrays.sort(nums2);
        
        int l1 = nums1.length;
        int l2 = nums2.length;
        int[] arr = new int[l1>l2?l2:l1];
        
        int i=0;
        int j=0;
        int k = 0;
        while(i<l1 && j<l2){
            if(nums1[i] < nums2[j]){
                i++;
            } else if(nums1[i] > nums2[j]){
                j++;
            } else {
                arr[k] = nums1[i];
                k++;
                i++;
                j++;
            }
        }
        
        int[] temp = new int[k];
        for(int q=0;q<k;q++){
            temp[q] = arr[q];
        }
        
        return temp;
    }
}
```

我的解法

```java
class Solution {
    public int[] intersect(int[] nums1, int[] nums2) {
            HashMap<Integer,Integer> map1 = tongji(nums1);
        HashMap<Integer,Integer> map2 = tongji(nums2);
        //查找
        ArrayList<Integer> result = new ArrayList<>();
        for (HashMap.Entry<Integer, Integer> entry : map1.entrySet()) {
            if (map2.containsKey(entry.getKey())){
                int a = map2.get(entry.getKey());
                int b = entry.getValue();
                if (a>b){
                    a = b;
                }
               for (int i = 0;i<a;i++){
                   result.add(entry.getKey());
               }
            }
        }
        int size = result.size();
        int[] array = new int[size];
        for (int i=0;i<size;i++){
            array[i] = (int)result.toArray()[i];
        }
        return array;
    }
    
    private static HashMap<Integer, Integer> tongji(int nums[]){
        HashMap<Integer,Integer> map = new HashMap();
        //统计
        for(int i=0;i<nums.length;i++){
            if(map.containsKey(nums[i])){
                int count = map.get(nums[i]) + 1;
                map.put(nums[i],count);
            }else {
                map.put(nums[i],1);
            }
        }
        return map;
    }
    
}
```

### 加一

给定一个由**整数**组成的**非空**数组所表示的非负整数，在该数的基础上加一。

最高位数字存放在数组的首位， 数组中每个元素只存储**单个**数字。

你可以假设除了整数 0 之外，这个整数不会以零开头。

```
输入: [1,2,3]
输出: [1,2,4]
解释: 输入数组表示数字 123。
```

```java
class Solution {
    public int[] plusOne(int[] digits) {

       Stack<Integer> stack = new Stack<>();
        boolean flag = false;
        digits[digits.length -1] += 1;
        for (int i = digits.length-1; i >= 0; i--) {
            if (digits[i] < 10) {
                return digits;
            } else {
                digits[i] = 0;
                if (i != 0) {
                    digits[i-1] += 1;
                } 

            }
        }
        int[] res = new int[digits.length + 1];
        res[0] = 1;
        System.arraycopy(digits, 0,res, 1, digits.length);
        return res;
        
    }
    
}
```

### 移动零

给定一个数组 `nums`，编写一个函数将所有 `0` 移动到数组的末尾，同时保持非零元素的相对顺序。

```
输入: [0,1,0,3,12]
输出: [1,3,12,0,0]
```

最快解法

```
class Solution {
    public void moveZeroes(int[] nums) {
        int i=0;
        for(int j=0;j<nums.length;j++){
            if(nums[j]!=0){
                nums[i]=nums[j];
                i++;
                }
            }
        for(int k=i;k<nums.length;k++){
            nums[k]=0;
            }
        
        
    }
}
```

我的解法

```
class Solution {
    public void moveZeroes(int[] nums) {
        int count = 0;
        for (int i = 0;i<nums.length;i++){
            if(nums[i]==0){
                count++;
                continue;
                
            }
            if(nums[i]!=0 && i!=0 && count !=0){
                nums[i-count] = nums[i];
                nums[i] = 0;
            }
        }
        
        for(int i:nums){
            System.out.print(i+" ");
        }
    }
}
```

### 两数之和

给定一个整数数组 `nums` 和一个目标值 `target`，请你在该数组中找出和为目标值的那 **两个** 整数，并返回他们的数组下标。

你可以假设每种输入只会对应一个答案。但是，你不能重复利用这个数组中同样的元素。

```
给定 nums = [2, 7, 11, 15], target = 9

因为 nums[0] + nums[1] = 2 + 7 = 9
所以返回 [0, 1]
```

最快解法

```
class Solution {
    public int[] twoSum(int[] nums, int target) {
         int indexArrayMax = 2047;
        int[] indexArray = new int[indexArrayMax + 1];
        for(int i=0;i<indexArrayMax+1;i++){
            indexArray[i]=-1;
        }
        int diff = 0;
        for (int i=0; i<nums.length; i++) {
            diff = target - nums[i];
            if (indexArray[diff & indexArrayMax] != -1) {
                return new int[]{indexArray[diff & indexArrayMax], i};
            }
            indexArray[nums[i] & indexArrayMax] = i;
        }
        return null;
    }
}
```



我的解法

```
class Solution {
    public int[] twoSum(int[] nums, int target) {
       Map<Integer,Integer> map = new HashMap<Integer,Integer>();
        Map<Integer,Integer> map2 = new HashMap<Integer,Integer>();
        int[] array= new int[2];
        for(int i = 0;i<nums.length;i++){
            if(map.containsKey(nums[i])){
                 array[1] = i;
                array[0] = map2.get(target-nums[i]);
               
                break;
            }
            map.put(target-nums[i],i);
            map2.put(nums[i],i);
        }
       return array;
    }
}
```



最快解法

```
 int[] rows = new int[9];
        int[] cols = new int[9];
        int[] blks = new int[9];
        for(int ri = 0; ri < 9; ++ri){
            for(int ci = 0; ci < 9; ++ci){
                if(board[ri][ci] != '.'){
                    int bi = ri / 3 * 3 + ci / 3;
                    int uvb = 1 << (board[ri][ci] - '0');
                    if((uvb & (rows[ri] | cols[ci] | blks[bi])) != 0)
                        return false;
                    rows[ri] |= uvb;
                    cols[ci] |= uvb;
                    blks[bi] |= uvb;
                }
            }
        }
        return true;
```

